class Agreement < ActiveRecord::Base
  attr_accessible :code, :year, :section, :title, :agreement_date, :signature_date,
    :validity_date, :signatories, :dga_contribution, :another_contributions, :amount,
    :addendums, :observations, :notes, :pdf_url
end
