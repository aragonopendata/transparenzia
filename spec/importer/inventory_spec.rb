require 'spec_helper'
require 'csv'
require 'importer/inventory'

describe Inventory do
  it "load csv" do
    csv = CSV.read("spec/importer/data/inmuebles.csv")
    previous_size = csv.size
    inventory = Inventory.new(csv)
    previous_size.should eq (inventory.data.size + 1)
    inventory.columns[0].should eq 'ID'
    inventory.data[0]['ID'].should_not eq nil 
  end

  it "save to database" do
    csv = CSV.read("spec/importer/data/inmuebles.csv")
    inventory = Inventory.new(csv)
    inventory.save
    inventory.collection.size.should eq inventory.data.size
  end
end