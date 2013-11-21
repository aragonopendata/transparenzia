require 'spec_helper'
require 'importer/personal'

describe PersonalImporter do
  before do
    @text = open("spec/importer/data/personal/BLOQUE1.csv").read
  end
  it "load csv from text" do
    importer = PersonalImporter.new(@text)
    importer.keys[0].should eq 'Nº pers'
    importer.data[0]['Nº pers'].should_not eq nil
  end

  it "save to database" do
    importer = PersonalImporter.new(@text)
    importer.save
    people = Personal.all
    people.size.should eq importer.data.size
  end

  it "add payroll to workpeople" do
    payroll_text = open("spec/importer/data/personal/B3_parte1.csv").read
    importer = PersonalImporter.new(@text, payroll_text)
    importer.save
    person = Personal.first
    puts person.inspect
    person.payroll.should_not eq nil
  end
end