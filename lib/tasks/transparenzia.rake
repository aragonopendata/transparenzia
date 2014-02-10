require 'importer/personal'
require 'importer/inventory'
require 'importer/agreement'

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

  desc "Import agreement data from Aragon Open Data portal"
  task :import_opendata_agreements => :environment do
    Signatories.instance.clean
    (2008..2014).to_a.each do |year|
      json_text = open("http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VERLST&OUTPUTMODE=JSON&BASE=RECO&DOCS=1-100000&SEC=OPENDATARECOJSON&SORT=-ANNO%2C-NUME&OPDEF=%26&SEPARADOR=&%40ANNO-GE=#{year}&%40ANNO-LE=#{year}").read
      puts "Imported agreements data from #{year}"
      importer = AgreementImporter.new(json_text)
      importer.save
    end
  end
end