class Agreement < ActiveRecord::Base
  attr_accessible :code, :year, :section, :title, :agreement_date, :signature_date,
    :validity_date, :signatories, :number_of_signatories, :dga_contribution, :another_contributions, :amount,
    :addendums, :observations, :notes, :pdf_url, :total_amount, :total_dga_contribution,
    :dga_contribution_percentage

  def pdf_urls
    urls = []
    self.pdf_url.split("http://").each{ |url|
      if url.size > 0
        urls << "http://#{url}"
      end
    }
    urls
  end
end
