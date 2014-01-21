module AgreementsHelper
  def older_year(agreements)
    agreements.min_by{|agreement| agreement.year}.year
  end
  def number_of_entities(agreements)
    signatories = {}
    agreements.each do|agreement| 
      agreement.signatories.split("/").each do |signatory|
        signatories[signatory.downcase.split] = signatory
      end
    end
    signatories.size
  end

  def agreements_chart(agreements)
    group = group_by_month(agreements)
    html = "<ul class=\"agreements_by_month_list\">"
    case params[:type]
    when "amount"
      agreements_amount_by_moth group, html
    else
      number_of_agreements_by_moth group, html
    end
    html << "</ul>"
    html.html_safe
  end

  def number_of_agreements_by_moth(group, html)
    group.sort.each_with_index do |(month, agreements), index|
      month = I18n.t("date.month_names")[month]
      html << "<li>Mes: <span class='key'>#{index}</span> <span class='label'>#{month}: #{agreements.size} convenios </span>. Número de convenios: <span class='value'>#{agreements.size}</span>.</li>"
    end
  end
  def agreements_amount_by_moth(group, html)
    group.sort.each_with_index do |(month, agreements), index|
      total_amount = 0
      agreements.collect{|agreement| total_amount =+ agreement.total_amount.round}
      month = I18n.t("date.month_names")[month]
      html << "<li>Mes: <span class='key'>#{index}</span> <span class='label'>#{month}: <span class='value'>#{total_amount}</span> € en total</span></li>"
    end
  end

  def agreements_by_number_of_signatories(agreements)
    total_size = agreements.size
    group = agreements.group_by do |agreement| 
      agreement.number_of_signatories
    end
    html = "<ul class=\"agreements_by_signatories_list\">"
    group.sort.each do |number_of_signatories, agreements|
      percentage = (agreements.size.to_f / total_size * 100).round(2)
      html << "<li><span class='label'>#{percentage}%</span><span class='key'>#{number_of_signatories}</span> firmantes han firmado <span class='value'>#{agreements.size}</span> convenios.</li>"
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
    agreements_with_amount = agreements.reject{|agreement| agreement.total_amount <= 0}
    number_with_precision(agreements_with_amount.min_by{|agreement| agreement.total_amount}.total_amount, :precision => 2)
  end

  def dga_contribution_percentage(agreements)
    agreements_with_amount = agreements.reject{|agreement| agreement.total_amount <= 0}
    agreements_with_contribution = agreements_with_amount.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    total_percentage = 0
    agreements_with_contribution.each do |agreement|
      total_percentage += agreement.dga_contribution_percentage
    end
    if agreements_with_amount.size > 0
      percentage = total_percentage / agreements_with_amount.size * 100
      number_with_precision(percentage, :precision => 1)
    end
  end

  def highest_dga_contribution_percentage(agreements)
    agreements_with_contribution = agreements.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    agreement = agreements_with_contribution.max_by{|agreement| agreement.dga_contribution_percentage}
    number_with_precision(agreement.dga_contribution_percentage*100, :precision=>2) if agreement
  end

  def lowest_dga_contribution_percentage(agreements)
    agreements_with_amount = agreements.reject{|agreement| agreement.total_amount <= 0}
    agreements_with_contribution = agreements_with_amount.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    agreement = agreements_with_contribution.min_by{|agreement| agreement.dga_contribution_percentage}
    number_with_precision(agreement.dga_contribution_percentage*100, :precision=>2) if agreement
  end

private
  def group_by_month(agreements)
    group = agreements.group_by do |agreement| 
      agreement.agreement_date.month
    end
    group.keys
    group
  end

  def group_by_year(agreements)
    group = agreements.group_by do |agreement| 
      agreement.agreement_date.year
    end
    group
  end
end