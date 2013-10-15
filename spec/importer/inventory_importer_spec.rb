require 'spec_helper'
require 'importer/inventory_importer'

describe InventoryImporter do
  it "load csv from text" do
    text = open("spec/importer/data/inmuebles.csv")
    inventory = InventoryImporter.new(text)
    inventory.keys[0].should eq 'ID'
    inventory.data[0]['ID'].should_not eq nil 
  end

  it "save to database" do
    text = open("spec/importer/data/inmuebles.csv")
    inventory = InventoryImporter.new(text)
    inventory.save
    properties = Properties.all
    properties.size.should eq inventory.data.size
  end
end