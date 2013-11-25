class PersonalController < ApplicationController
  def index
    @people = Personal.all.to_a
    puts @people.first.inspect
    @highest = @people.max_by{|person| person.payroll.to_i}
    @lowest = @people.min_by{|person| person.payroll.to_i}
    payrolls = @people.collect{|person| person.payroll.to_i}
    @payrolls_average = average(payrolls)

    @older = @people.max_by{|person| person.age}
    @younger = @people.min_by{|person| person.age}
    ages = @people.collect{|person| person.age}
    @ages_average = average(ages)

    @veteran = @people.max_by{|person| person.triennia}
    @rookie = @people.min_by{|person| person.triennia}
    puts @rookie
    triennia = @people.collect{|person| person.triennia}
    @triennia_average = average(triennia)
    

    @titulations = @people.collect{|person| [person['GR_Titulac'], person['Desc_GR_titulac']]}.uniq
    @modes = @people.collect{|person| [person['Modalidad'], person['Desc Modalidad']]}.uniq
    @divisions = @people.collect{|person| [person['División de personal'], person['División de personal']]}.uniq
    @subdivisions = @people.collect{|person| [person['SubPer'], person['Subdivisión de personal']]}.uniq
    @groups = @people.collect{|person| [person['GrPer'], person['Grupo de personal']]}.uniq
    @areas = @people.collect{|person| [person['ÁPers'], person['Área de personal']]}.uniq
  end

  def average(arr)
    arr.inject{ |sum, el| sum + el }.to_i / arr.size
  end
end
