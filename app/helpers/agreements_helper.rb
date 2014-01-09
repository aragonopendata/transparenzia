module AgreementsHelper
  def older_year(agreements)
    agreements.min_by{|agreement| agreement.year}.year
  end
  def number_of_entities(agreements)
    signatories = {}
    agreements.each do|agreement| 
      agreement.signatories.split("/").each do |signatory|
        signatories[signatory] = signatory
      end
    end
    signatories.size
  end

  def agreements_by_moth(agreements)
    #we should move this code...
    group = agreements.group_by do |agreement| 
      if agreement.agreement_date
        agreement.agreement_date.month
      else
        agreement.signature_date.month
      end
    end
    
    html = "<ul>"
    group.sort.each do |month, agreements|
       html << "<li>Mes: #{month}. Número de convenios: #{agreements.size}.</li>"
    end
    html << "</ul>"
    html.html_safe
  end

  def total_of_amount_agreements(agreements)
    size = 0
    total = 0
    agreements.each do |agreement|
      if agreement.amount and not agreement.amount.empty?
        amount = clean_number_format(agreement.amount)
        if is_a_number?(amount)
          total += amount.to_f
          size += 1
        else
          numbers = get_all_the_numbers_in_string(amount)
          puts numbers
          unless numbers.empty?
            size += 1 
            numbers.each do |number|
              number = number.to_f
              if number > 1000
                total +=  number
              end
            end
          end
        end
      end
    end
    total
  end



private
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