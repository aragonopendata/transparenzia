require 'spec_helper'

describe Agreement do
  it "split pdf_url in name and url" do
    @agreement = Agreement.new
    @agreement.pdf_url = "<enlace>http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VEROBJ&MLKOB=326175233734 <descripcion> Convenio </descripcion> </enlace>"
    pdfs = @agreement.pdf_urls
    pdfs.size.should eq 1
    pdfs.first[:url].should eq "http://www.boa.aragon.es/cgi-bin/RECO/BRSCGI?CMD=VEROBJ&MLKOB=326175233734"
    pdfs.first[:description].should eq "Convenio"
  end
end
