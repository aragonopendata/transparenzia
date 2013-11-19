require 'mongo'
require 'csv'

class PersonalImporter
  attr_accessor :keys, :data
  def initialize(text, payroll_text="")
    initialize_payroll(payroll_text)

    csv = CSV.parse(text.delete('#'))
    @keys = csv.shift
    @data = csv.collect{ |line|
      item = {}
      @keys.each_index { |key_index|
        column = @keys[key_index]
        item[column] = line[key_index]
      }

      if @payroll_hash
        add_payroll(item)
      else
        item
      end
    }
  end

  def save
    People.save(@data)
  end

  private 
    def initialize_payroll(payroll_text)
      @payroll_hash = nil
      if payroll_text!=""
        payroll_csv = CSV.parse(payroll_text)
        @payroll_descriptor = payroll_csv.shift[1]
        @payroll_hash = Hash[payroll_csv]
      end
    end
    def add_payroll(item)
      payroll = @payroll_hash[item['Nº pers']]
      item[@payroll_descriptor] = payroll
      item
    end
end

class People
  def self.all
    mongo_client = Mongo::MongoClient.new
    @db = mongo_client.db("transparenzia")
    @db.collection("personal")
  end

  def self.save(new_data)
    collection = self.all
    collection.remove
    new_data.each{ |item|
      collection.insert(item)
    }
  end
end