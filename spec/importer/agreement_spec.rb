require 'spec_helper'
require 'open-uri'
require 'importer/agreement'

describe AgreementImporter do
  describe "agreement importation form open data portal" do
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
  describe "normalize sections, before 2013 are different than now" do
    it "state administration is mapped to 1, 2 and 3 sheets" do
      normalize_section("2 Administración General / foobar").should eq Agreement::STATE_SECTION
      normalize_section("1 Cortes Generales").should eq Agreement::STATE_SECTION
      normalize_section("3 Consejo General del Poder Judicial").should eq Agreement::STATE_SECTION
    end
    it "state administration is mapped to section 1" do
      normalize_section("S1 Sección del Estado").should eq Agreement::STATE_SECTION
    end
    it "autonomies are mapped to 4 sheet" do
      normalize_section("4 Comunidades Autónomas").should eq Agreement::AUTONOMY_SECTION
    end
    it "autonomies are mapped to section 2" do
      normalize_section("S2 Sección de las Comunidades Autónomas").should eq Agreement::AUTONOMY_SECTION
    end
    it "town hall and counties are mapped to sheet 5" do
      normalize_section("5 Corporaciones Locales").should eq Agreement::LOCAL_SECTION
    end
    it "town hall and counties are mapped to section 6" do
      normalize_section("S6 Sección de las Corporaciones Locales").should eq Agreement::LOCAL_SECTION
    end
    it "other public entities are mapped to sheet 6" do
      normalize_section("6 Otras entidades publicas españolas o extranjeras").should eq Agreement::OTHER_PUBLIC_SECTION
    end
    it "other public entities are mapped to section 3 and 5" do
      normalize_section("S3 Sección de los entes públicos e Instituciones de otros Estados u organismos internacionales y otras entidades públicas").should eq Agreement::OTHER_PUBLIC_SECTION
      normalize_section("S5 Sección de las Corporaciones de Derecho Público").should eq Agreement::OTHER_PUBLIC_SECTION
    end

    it "if not match in any sections an sheets is other entity, private in this case" do
      normalize_section("foo").should eq Agreement::OTHER_SECTION
    end

  end
end