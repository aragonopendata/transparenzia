class Agreement < ActiveRecord::Base
  VALID = "0"
  INVALID = "1"

  STATE_SECTION = 1
  AUTONOMY_SECTION = 2
  LOCAL_SECTION = 3
  OTHER_PUBLIC_SECTION = 4
  OTHER_SECTION = 5

  SECTIONS = {STATE_SECTION => "state", AUTONOMY_SECTION => "autonimies", LOCAL_SECTION => "local", OTHER_PUBLIC_SECTION => "other public entities", OTHER_SECTION => "other"}

  attr_accessible :code, :year, :section, :title, :agreement_date, :signature_date,
    :validity_date, :signatories, :number_of_signatories, :dga_contribution, :another_contributions, :amount,
    :addendums, :observations, :notes, :pdf_url, :total_amount, :total_dga_contribution,
    :dga_contribution_percentage, :normalized_section

  scope :valid, ->(val) { where("validity_date > ?", DateTime.now.to_date) if val == VALID}
  scope :invalid, ->(val) { where("validity_date < ?", DateTime.now.to_date) if val == INVALID}
  scope :between_dates, -> (year_ini, year_end) {
    year_ini = 2008 if (year_ini < 2008)
    year_end = 2013 if (year_end < 2008)
    year_ini = Date.new(year_ini, 1, 1)
    year_end = Date.new(year_end, 12, 31)
    where(:agreement_date => year_ini..year_end)
  }
  scope :find_by_title, -> (title) {
    title = title ? "%#{title}%": "%"
    where("lower(title) like lower(?)", title)
  }
  scope :find_by_signatories , -> (signatories) {
    signatories = signatories ? "%#{signatories}%": "%"
    where("lower(signatories) like lower(?)", signatories)
  }
  scope :order_by, -> (type) {
    case type
    when "amount"
      order_by = "total_amount"
    when "entities"
      order_by = "number_of_signatories"
    when "percentage"
      order_by = "dga_contribution_percentage"
    else
      order_by = "id"
    end
    order("#{order_by} DESC")
  }

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
