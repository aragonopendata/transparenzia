class PersonalController < ApplicationController
  def index
    @people = Personal.all.to_a

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
