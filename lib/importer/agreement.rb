require 'json'
require 'iconv'

def normalize_section(unnormalized_section)
  if unnormalized_section
    if unnormalized_section.start_with?("1 Cortes") or unnormalized_section.start_with?("2 Administración") or 
     unnormalized_section.start_with?("3 Consejo") or unnormalized_section.start_with?("S1")
      Agreement::STATE_SECTION
    elsif unnormalized_section.start_with?("4 Comunidades") or unnormalized_section.start_with?("S2")
      Agreement::AUTONOMY_SECTION
    elsif unnormalized_section.start_with?("5 Corporaciones") or unnormalized_section.start_with?("S6")
      Agreement::LOCAL_SECTION
    elsif unnormalized_section.start_with?("6 Otras entidades") or unnormalized_section.start_with?("S3") or
     unnormalized_section.start_with?("S5")
      Agreement::OTHER_PUBLIC_SECTION
    else
      Agreement::OTHER_SECTION
    end
  end
end

class AgreementImporter
  attr_accessor :data
  @data
  def initialize(doc)
    #i = Iconv.new('UTF-8','LATIN1')
    #doc = i.iconv(doc)
    @data = Hash.from_xml(doc)["documento"]["registro"]
  end

  def save
    Agreement.destroy_all(:year => @data.first['anno'])
    @data.each do |item|
      if item['firmantes']
        begin
          agreement = Agreement.new(
              :code => item['numero'],
              :year => item['anno'].to_i, 
              :section => item['seccion'], 
              :normalized_section => normalize_section(item['seccion']),
              :title => item['titulo'], 
              :signatories => item['firmantes'], 
              :number_of_signatories => item['firmantes'].split("/").size, 
              :dga_contribution => item['aportaciondga'], 
              :another_contributions => item['otrasaportaciones'],
              :amount => item['cuantia'],
              :addendums => item['addendas'],
              :observations => item['observaciones'],
              :notes => item['notasmarginales'],
              :pdf_url => item['urlpdf'].gsub("´", "").strip()
            )
          populate_dates(agreement, item)
          total_of_amount(agreement)
          if agreement.year and agreement.year >= 2008 
            total_dga_contribution(agreement)
            dga_contribution_percentage(agreement)
          end
          agreement.save!

          Signatories.instance.populate(agreement.signatories)
        rescue Exception => e
          puts "Error for #{item}"
          raise e
        end
      end
    end
    Signatories.instance.serialize
  end

private

  def populate_dates(agreement, item)
    agreement_date = convert_text_to_date(item['fechaacuerdo'])
    signature_date = convert_text_to_date(item['fechafirma'])
    agreement.validity_date = convert_text_to_date(item['fechavigencia'])
    unless agreement_date
      agreement_date = signature_date
    end
    unless signature_date
      signature_date = agreement_date
    end
    agreement.agreement_date = agreement_date
    agreement.signature_date = signature_date
    agreement
  end

  def convert_text_to_date(text)
    begin
      date = (text!="") ? Date.strptime(text, "%Y%m%d"): nil
    rescue
      date = nil
    end
    if date and date.gregorian?
      date
    end
  end

  def total_of_amount(agreement)
    agreement.total_amount = sumatory_of_numbers_in_string(agreement.amount)
  end

  def total_dga_contribution(agreement)
    agreement.total_dga_contribution = sumatory_of_numbers_in_string(agreement.dga_contribution)
  end

  def dga_contribution_percentage(agreement)
    if agreement.total_amount > 0
      agreement.dga_contribution_percentage = (agreement.total_dga_contribution / agreement.total_amount)
    end
  end

  def sumatory_of_numbers_in_string(string)
    total = 0
    if string and not string.empty?
      string = clean_number_format(string)
      if is_a_number?(string)
        total += string.to_f
      else
        numbers = get_all_the_numbers_in_string(string)
        unless numbers.empty?
          numbers.each do |number|
            number = number.to_f
            if number > 1000 #if is less than 1000 euros is desestimated, look like a date year
              total +=  number
            end
          end
        end
      end
    end
    total
  end

  def is_a_number?(string)
    /\A[-+]?[0-9]*\.?[0-9]+\Z/.match(string)
  end

  def get_all_the_numbers_in_string(string)
    string.scan /[-+]?[0-9]+\.?[0-9]+/
  end

  def clean_number_format(string)
    string.gsub!('.','') #for clean thousands separation in some number formats
    string.gsub!(',','.') #for change comma decimal separation to dots
    string.strip
  end
end