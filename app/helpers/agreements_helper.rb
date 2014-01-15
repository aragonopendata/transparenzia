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
       html << "<li>Mes: <span class='key'>#{month}</span> <span class='label'>#{Date::MONTHNAMES[month]}</span>. Número de convenios: <span class='value'>#{agreements.size}</span>.</li>"
    end
    html << "</ul>"
    html.html_safe
  end

  def total_of_amount_agreements(agreements)
    total = 0
    agreements.each do |agreement|
      total += agreement.total_amount
    end
    number_with_precision(total, :precision => 2)
  end

  def highest_amount_agreement(agreements)
    number_with_precision(agreements.max_by{|agreement| agreement.total_amount}.total_amount, :precision => 2)
  end

  def lowest_amount_agreement(agreements)
    agreements.delete_if{|agreement| agreement.total_amount <= 0}
    number_with_precision(agreements.min_by{|agreement| agreement.total_amount}.total_amount, :precision => 2)
  end

  def dga_contribution_percentage(agreements)
    agreements = agreements.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    total_percentage = 0
    agreements.each do |agreement|
      total_percentage += agreement.dga_contribution_percentage
    end
    if agreements.size > 0
      percentage = total_percentage / agreements.size * 100
      number_with_precision(percentage, :precision => 2)
    end
  end

  def highest_dga_contribution_percentage(agreements)
    agreements = agreements.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    agreement = agreements.max_by{|agreement| agreement.dga_contribution_percentage}
    number_with_precision(agreement.dga_contribution_percentage*100, :precision=>2) if agreement
  end

  def lowest_dga_contribution_percentage(agreements)
    agreements = agreements.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    agreement = agreements.min_by{|agreement| agreement.dga_contribution_percentage}
    number_with_precision(agreement.dga_contribution_percentage*100, :precision=>2) if agreement
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