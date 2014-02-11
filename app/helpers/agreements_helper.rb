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
    year = nil
    if params[:year_ini] == params[:year_end] and params[:year_ini] and params[:year_ini] != ""
      year = params[:year_ini]
      group = group_by_month(agreements)
    else
      group = group_by_year(agreements)
    end
    
    html = "<ul class=\"agreements_by_month_list\">"
    case params[:type]
    when "amount"
      agreements_amount_by_interval_time group, html, year
      title = "Cuantía de convenios"
      xtitle = "€ en total"
    when "entities"
      number_of_entities_participating_by_interval_time group, html, year
      title = "Número de entidades"
      xtitle = "Cantidad"
    when "percentage"
        percentage_of_dga_participation_by_interval_time  group, html, year
        title = "Porcentaje de participación"
        xtitle = "% aportado"
    else
      number_of_agreements_by_interval_time group, html, year
      title = "Número de convenios"
      xtitle = "Cantidad"
    end
    html << "</ul>"
    html << "<div class='chart-title' style='display:none'>#{title}</div>"
    html << "<div class='units-y' style='display:none'>#{xtitle}</div>"
    html.html_safe
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
    agreement = agreements_with_amount.min_by{|agreement| agreement.total_amount}
    if agreement 
      number_with_precision(agreement.total_amount, :precision => 2) 
    else 
      0 
    end
  end

  def dga_contribution_percentage(agreements)
    agreements_with_amount = agreements.reject{|agreement| agreement.total_amount <= 0}
    agreements_with_contribution = agreements_with_amount.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    total_percentage = 0
    agreements_with_contribution.each do |agreement|
      total_percentage += agreement.dga_contribution_percentage
    end
    percentage = 0
    if agreements_with_amount.size > 0
      percentage = total_percentage / agreements_with_amount.size * 100
    end
    number_with_precision(percentage, :precision => 1)
  end

  def highest_dga_contribution_percentage(agreements)
    agreements_with_contribution = agreements.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    agreement = agreements_with_contribution.max_by{|agreement| agreement.dga_contribution_percentage}
    if agreement 
      number_with_precision(agreement.dga_contribution_percentage*100, :precision=>1) 
    else 
      0
    end
  end

  def lowest_dga_contribution_percentage(agreements)
    agreements_with_amount = agreements.reject{|agreement| agreement.total_amount <= 0}
    agreements_with_contribution = agreements_with_amount.find_all{|agreement| agreement.dga_contribution_percentage != nil}
    agreement = agreements_with_contribution.min_by{|agreement| agreement.dga_contribution_percentage}
    if agreement 
      number_with_precision(agreement.dga_contribution_percentage*100, :precision=>2) 
    else 
      0
    end
  end

private
  def group_by_month(agreements)
    group = agreements.group_by do |agreement| 
      agreement.agreement_date.month
    end
    #populate the empty months
    (1..12).each do |it|
      unless group[it]
        group[it] = []
      end
    end
    group.sort
  end

  def group_by_year(agreements)
    group = agreements.group_by do |agreement| 
      agreement.agreement_date.year
    end
    #populate the empty years
    year_ini = params[:year_ini].to_i
    year_end = params[:year_end].to_i
    year_ini = 2008 if year_ini < 2008
    year_end = Date.today.year if year_end < 2008
    (year_ini..year_end).each do |it|
      unless group[it]
        group[it] = []
      end
    end
    group.sort
  end

  def number_of_agreements_by_interval_time(group, html, year=nil)
    group.each_with_index do |(grouped_by, agreements), index|
      if year
        grouped_by = I18n.t("date.month_names")[grouped_by]
      else
        grouped_by = "#{grouped_by}"
      end
      html << "<li><span class='key'>#{index}</span> <span class='label'>#{grouped_by}</span>. Número de convenios: <span class='value'>#{agreements.size}</span>.</li>"
    end
  end
  def agreements_amount_by_interval_time(group, html, year=nil)
    group.each_with_index do |(grouped_by, agreements), index|
      if year
        grouped_by = I18n.t("date.month_names")[grouped_by]
      else
        grouped_by = "#{grouped_by}"
      end
      total_amount = 0
      agreements.each{|agreement| total_amount = total_amount + agreement.total_amount.round}
      html << "<li><span class='key'>#{index}</span> <span class='label'>#{grouped_by}</span> <span class='value'>#{total_amount}</span></li>"
    end
  end
  def percentage_of_dga_participation_by_interval_time(group, html, year=nil)
    group.each_with_index do |(grouped_by, agreements), index|
      if year
        grouped_by = I18n.t("date.month_names")[grouped_by]
      else
        grouped_by = "#{grouped_by}"
      end
      acumulated_percentage = 0
      agreements = agreements.find_all{|agreement| agreement.dga_contribution_percentage != nil}
      agreements.each{|agreement| acumulated_percentage = acumulated_percentage + agreement.dga_contribution_percentage}
      percentage = 0
      if agreements.size > 0
        percentage = (acumulated_percentage/ agreements.size * 100).round(2)
      end
      
      html << "<li><span class='key'>#{index}</span> <span class='label'>#{grouped_by}</span> <span class='value'>#{percentage}</span> %</span>.</li>"
    end
  end
  def number_of_entities_participating_by_interval_time(group, html, year=nil)
    group.each_with_index do |(grouped_by, agreements), index|
      number_of_entities = 0
      if year
        grouped_by = I18n.t("date.month_names")[grouped_by]
      else
        grouped_by = "#{grouped_by}"
      end
      agreements.each{|agreement| number_of_entities = number_of_entities+ agreement.number_of_signatories}
      html << "<li><span class='key'>#{index}</span> <span class='label'>#{grouped_by}</span> <span class='value'>#{number_of_entities}</span></span>.</li>"
    end
  end
  def active(type=nil)
    if (type == params[:type])
      "active"
    else 
      ""
    end
  end
  def filter_text()
    text = ""
    if params[:validity_date]=="0"
        text << "vigentes "
    end
    if params[:validity_date]=="1"
        text << "no vigentes "
    end
    if params[:year_ini] 
        if params[:year_ini] != ""
          text << "desde #{params[:year_ini]} "
        else
          text << "desde 2008 "
        end
    end
    if params[:year_end]
        if params[:year_end] != ""
          text << "hasta #{params[:year_end]} "
        else
          text << "hasta 2013 "
        end
    end
    if params[:title] and params[:title]!=''
        text << "cuyo título contenga '#{params[:title]}' "
    end
    if params[:signatories] and params[:signatories]!=''
        text << "el firmante sea '#{params[:signatories]}' "
    end
    if params[:section] and params[:section]!=''
        text << "de la sección '#{params[:section]}' "
    end
    text
  end
end