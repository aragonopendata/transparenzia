require 'mongo'
require 'csv'

class InventoryImporter
  attr_accessor :keys, :data
	@keys
  @data
  @db
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

    mongo_client = Mongo::MongoClient.new
    @db = mongo_client.db("transparenzia")
  end

  def save
    collection = @db.collection("inventory")
    collection.remove
    @data.each{ |item|
      collection.insert(item)
    }
  end

  def collection
    collection = @db.collection("inventory")
  end
end