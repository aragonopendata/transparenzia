require 'spec_helper'
require 'open-uri'
require 'importer/agreement'

describe AgreementImporter do
  before(:each) do
    doc = open('http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VERLST&OUTPUTMODE=JSON&BASE=RECO&DOCS=1-100000&SEC=OPENDATARECOJSON&SORT=-ANNO%2C-NUME&OPDEF=%26&SEPARADOR=&%40ANNO-GE=1984&%40ANNO-LE=1984').read
    Agreement.delete_all
    @importer = AgreementImporter.new(doc)
  end

  it "loading the document should load the data" do
    @importer.data.size.should eq 4
    @importer.keys[0].should eq 'Año'
    @importer.data[0]['Año'].should eq '1984'
  end

  it "saving to the database the data should be stored" do
    @importer.save
    Agreement.all.size.should eq @importer.data.size
    Agreement.all.size.should eq Agreement.where(:year => '1984').size
  end


  it "saving to the database the same year two times" do
    @importer.save
    first_time_size = Agreement.all.size
    @importer.save
    Agreement.all.size.should eq first_time_size
  end

  it "saving to the database different years" do
    @importer.save
    doc = open('http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VERLST&OUTPUTMODE=JSON&BASE=RECO&DOCS=1-100000&SEC=OPENDATARECOJSON&SORT=-ANNO%2C-NUME&OPDEF=%26&SEPARADOR=&%40ANNO-GE=1985&%40ANNO-LE=1985').read
    i = Iconv.new('UTF-8','LATIN1')
    doc = i.iconv(doc)
    doc = doc.split('<!--')[0]
    @second_importer = AgreementImporter.new(doc)
    total_size = @importer.data.size + @second_importer.data.size
    @second_importer.save
    Agreement.all.size.should eq total_size
  end
end