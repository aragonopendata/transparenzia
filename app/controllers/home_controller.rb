class HomeController < ApplicationController
  def index
    mongo_client = Mongo::MongoClient.new
    db = mongo_client.db("transparenzia")
    @persons = db.collection("personal").find.to_a
    puts @persons.first
    @titulations = @persons.collect{|person| [person['GR_Titulac'], person['Desc_GR_titulac']]}.uniq
    @modes = @persons.collect{|person| [person['Modalidad'], person['Desc Modalidad']]}.uniq
    @divisions = @persons.collect{|person| [person['DivP'], person['División de personal']]}.uniq
    @subdivisions = @persons.collect{|person| [person['SubPer'], person['Subdivisión de personal']]}.uniq
    @groups = @persons.collect{|person| [person['GrPer'], person['Grupo de personal']]}.uniq
    @areas = @persons.collect{|person| [person['ÁPers'], person['Área de personal']]}.uniq
    
  end
end
