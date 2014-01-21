require 'spec_helper'

describe Signatories do
  before(:each) do
    @signatories = Signatories.instance
    @signatories.clean
  end
  describe "populate" do
    it "from a couple of agreements" do
      @signatories.populate("DGA/Ayto. de San Esteban de Litera")
      @signatories.populate("SALUD/Diputación de Huesca")
      @signatories.all.size.should eq 4
    end
    it "from a couple of agreements with repeated signatories" do
      @signatories.populate("DGA/Diputación de Huesca")
      @signatories.populate("SALUD/Diputación de Huesca")
      @signatories.all.size.should eq 3
    end
  end
  describe "find" do
    it "all the elements that match on any position" do
      @signatories.populate("DGA/Ayto. de San Esteban de Litera")
      @signatories.populate("SALUD/Diputación de Huesca")
      matches = @signatories.find("SAL")
      matches.size.should eq 1
      matches[0] = "SALUD"
    end
  end
  describe "serialization" do
    it "to a file" do
      @signatories.populate("DGA/Ayto. de San Esteban de Litera")
      @signatories.serialize("tmp/test.yml")
      File.exist?("tmp/test.yml").should be_true
    end

  end
end
