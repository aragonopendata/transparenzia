require 'spec_helper'
require 'importer/personal'

describe PersonalImporter do
  it "load csv from text" do
    text = open("spec/importer/data/personal/BLOQUE1.csv").read
    importer = PersonalImporter.new(text)
    importer.keys[0].should eq 'Nº pers'
    importer.data[0]['Nº pers'].should_not eq nil
  end

  it "save to database" do
    text = open("spec/importer/data/personal/BLOQUE1.csv").read
    importer = PersonalImporter.new(text)
    importer.save
    persons = Persons.all
    persons.size.should eq importer.data.size
  end
end