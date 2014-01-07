require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PersonalHelper. For example:
#
# describe PersonalHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe AgreementsHelper do
  describe "Number of entities should retrieve all the signatories of all agreemets in the collection" do
    it "should be zero if is an empty collection" do
      number_of_entities([]).should eq 0
    end
    #at this moment this possibility is not posible, we always have 2 signatures by agreement
    it "should be the simple summatory if each agreement has only one signatory" do
      agreements = [
        stub_model(Agreement, :signatories => "DGA"),
        stub_model(Agreement, :signatories => "Ayto. de San Esteban de Litera")
      ]
      number_of_entities(agreements).should eq 2
    end
    it "should be the summatory of bar separated signatories by each agreement" do
      agreements = [
        stub_model(Agreement, :signatories => "DGA/Ayto. de San Esteban de Litera"),
        stub_model(Agreement, :signatories => "SALUD/Fundación Foo/Banco de Sangre")
      ]
      number_of_entities(agreements).should eq 5
    end
  end

end
