require 'mongo'
require 'csv'

class PersonalImporter
  attr_accessor :keys, :data
  def initialize(text)
    csv = CSV.parse(text.delete('#'))
    @keys = csv.shift
    
    @data = csv.collect{ |line|
      item = {}
      @keys.each_index { |key_index|
        column = @keys[key_index]
        item[column] = line[key_index]
      } 
      item
    }
  end

  def save
    People.save(@data)
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