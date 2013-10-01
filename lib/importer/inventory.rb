require 'mongo'

class Inventory
  attr_accessor :columns, :data
	@columns
  @data
  @db
  def initialize(csv)
    @columns = csv.shift
    @data = csv.collect{ |line|
      item = {}
      @columns.each_index { |column_index|
        column = @columns[column_index]
        item[column] = line[column_index]
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