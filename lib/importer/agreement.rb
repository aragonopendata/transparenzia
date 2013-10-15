require 'json'
require 'mongo'

class AgreementImporter
  attr_accessor :keys, :data
  @keys
  @data
  def initialize(doc)
    @data = JSON.parse(doc)
    @keys = @data.first.keys
  end

  def save
    Agreements.save(@data)
  end
end

class Agreements
  def self.all
    mongo_client = Mongo::MongoClient.new
    @db = mongo_client.db("transparenzia")
    @db.collection("agreement")
  end

  def self.all_by_year(year)
    self.all.find("Año" => year).to_a
  end

  def self.save(data_by_year)
    collection = self.all
    year = data_by_year.first["Año"]
    collection.remove("Año" => year)
    data_by_year.each{ |item|
      collection.insert(item)
    }
  end

  def self.remove_all
    self.all.remove
  end
end