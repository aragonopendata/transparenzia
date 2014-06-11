require 'importer/agreement'

namespace :transparenzia do
  desc "Import agreement data from Aragon Open Data portal"
  task :import_opendata_agreements => :environment do
    Signatories.instance.clean
    (2008..2014).to_a.each do |year|
      url = "http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VERLST&OUTPUTMODE=XML&BASE=RECO&DOCS=1-100000&SEC=OPENDATARECOXML&SORT=-ANNO%2C-NUME&OPDEF=%26&SEPARADOR=&%40ANNO-GE=#{year}&%40ANNO-LE=#{year}"
      puts "Downloading from #{url}"
      xml_text = open(url).read
      #json_text = open("http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VERLST&OUTPUTMODE=JSON&BASE=RECO&DOCS=1-100000&SEC=OPENDATARECOJSON&SORT=-ANNO%2C-NUME&OPDEF=%26&SEPARADOR=&%40ANNO-GE=#{year}&%40ANNO-LE=#{year}").read
      importer = AgreementImporter.new(xml_text)
      importer.save
      puts "Imported agreements data from #{year}"
    end
  end
end