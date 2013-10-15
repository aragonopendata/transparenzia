require 'open-uri'
require 'iconv'
require 'importer/agreement'

describe AgreementImporter do
  before(:each) do
    doc = open('http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VERLST&OUTPUTMODE=JSON&BASE=RECO&DOCS=1-100000&SEC=OPENDATARECOJSON&SORT=-ANNO%2C-NUME&OPDEF=%26&SEPARADOR=&%40ANNO-GE=1984&%40ANNO-LE=1984').read
    i = Iconv.new('UTF-8','LATIN1')
    doc = i.iconv(doc)
    doc = doc.split('<!--')[0]
    Agreements.remove_all
    @agreement = AgreementImporter.new(doc)
  end

  it "loading the document should load the data" do
    @agreement.data.size.should eq 4
    @agreement.keys[0].should eq 'Año'
    @agreement.data[0]['Año'].should eq '1984'
  end

  it "saving to the database the data should be stored" do
    @agreement.save
    Agreements.all.size.should eq @agreement.data.size
    Agreements.all.size.should eq Agreements.all_by_year('1984').size
  end


  it "saving to the database the same year two times" do
    @agreement.save
    first_time_size = Agreements.all.size
    @agreement.save
    Agreements.all.size.should eq first_time_size
  end

  it "saving to the database different years" do
    @agreement.save
    doc = open('http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VERLST&OUTPUTMODE=JSON&BASE=RECO&DOCS=1-100000&SEC=OPENDATARECOJSON&SORT=-ANNO%2C-NUME&OPDEF=%26&SEPARADOR=&%40ANNO-GE=1985&%40ANNO-LE=1985').read
    i = Iconv.new('UTF-8','LATIN1')
    doc = i.iconv(doc)
    doc = doc.split('<!--')[0]
    @second_agreement = AgreementImporter.new(doc)
    total_size = @agreement.data.size + @second_agreement.data.size
    @second_agreement.save
    Agreements.all.size.should eq total_size
  end
end