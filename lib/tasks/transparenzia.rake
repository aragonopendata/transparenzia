require 'importer/personal'
require 'importer/inventory'

namespace :transparenzia do

  desc "Import personal data"
  task :import_personal => :environment do
    text = open("spec/importer/data/personal/BLOQUE1.csv").read
    payroll_text = open("spec/importer/data/personal/B3_parte1.csv").read
    importer = PersonalImporter.new(text, payroll_text)
    importer.save
  end

  desc "Import inventory data"
  task :import_inventory => :environment do
    text = open("spec/importer/data/inmuebles.csv")
    importer = InventoryImporter.new(text)
    importer.save
  end
end