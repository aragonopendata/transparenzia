require 'mongo'
require 'csv'

class InventoryImporter
  attr_accessor :keys, :data
	@keys
  @data
  def initialize(text)
    csv = CSV.parse(text)
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
    Properties.save(@data)
  end
end

class Properties
  def self.all
    mongo_client = Mongo::MongoClient.new
    @db = mongo_client.db("transparenzia")
    @db.collection("inventory")
  end

  def self.save(new_data)
    collection = self.all
    collection.remove
    new_data.each{ |item|
      collection.insert(item)
    }
  end
end