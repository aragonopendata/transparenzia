class PersonalController < ApplicationController
  def index
    mongo_client = Mongo::MongoClient.new
    db = mongo_client.db("transparenzia")
    @people = db.collection("personal").find.to_a
    puts @people.first
    @highest = @people.max_by{|person| person['Bruto perc'].to_i}
    @lowest = @people.min_by{|person| person['Bruto perc'].to_i}
    payrolls = @people.collect{|person| person['Bruto perc'].to_i}
    @payrolls_average = average(payrolls)

    @older = @people.max_by{|person| person['Edad del empleado'].to_i}
    @younger = @people.min_by{|person| person['Edad del empleado'].to_i}
    ages = @people.collect{|person| person['Edad del empleado'].to_i}
    @ages_average = average(ages)

    @veteran = @people.max_by{|person| person['Trienios_nomina'].to_i}
    @rookie = @people.min_by{|person| person['Trienios_nomina'].to_i}
    triennia = @people.collect{|person| person['Trienios_nomina'].to_i}
    @triennia_average = average(triennia)
    

    @titulations = @people.collect{|person| [person['GR_Titulac'], person['Desc_GR_titulac']]}.uniq
    @modes = @people.collect{|person| [person['Modalidad'], person['Desc Modalidad']]}.uniq
    @divisions = @people.collect{|person| [person['División de personal'], person['División de personal']]}.uniq
    @subdivisions = @people.collect{|person| [person['SubPer'], person['Subdivisión de personal']]}.uniq
    @groups = @people.collect{|person| [person['GrPer'], person['Grupo de personal']]}.uniq
    @areas = @people.collect{|person| [person['ÁPers'], person['Área de personal']]}.uniq
    mongo_client.close
  end

  def average(arr)
    arr.inject{ |sum, el| sum + el }.to_i / arr.size
  end
end
