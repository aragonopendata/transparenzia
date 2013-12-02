module PersonalHelper
  def divisions
    Personal.all.to_a.collect{|person| person.department_description}.uniq
  end
  def modalities
    Personal.all.to_a.collect{|person| person.modality_description}.uniq
  end
  def highest_payroll(people)
    people.max_by{|person| person.payroll}.payroll
  end
  def lowest_payroll(people)
    people.min_by{|person| person.payroll}.payroll
  end
  def payroll_average(people)
    payrolls = people.collect{|person| person.payroll}
    average(payrolls)
  end
  def older_age(people)
    people.max_by{|person| person.age}.age
  end
  def younger_age(people)
    people.min_by{|person| person.age}.age
  end
  def age_average(people)
    ages = @people.collect{|person| person.age}
    average(ages)
  end
  def veteran_time(people)
    people.max_by{|person| person.triennia}.triennia * 3
  end
  def rookie_time(people)
    people.min_by{|person| person.triennia}.triennia * 3
  end
  def time_average(people)
    triennia = people.collect{|person| person.triennia}
    average(triennia * 3)
  end
  def number_of_men(people)
    people.to_a.count{|person| person.sex==1}
  end
  def number_of_women(people)
    people.to_a.count{|person| person.sex==2}
  end
  def payroll_average_by_place
    filter_people_results(Personal.payroll_average_by_place)
  end
  def payroll_average_by_department
    filter_people_results(Personal.payroll_average_by_department)
  end
  def payroll_average_by_titulation
    filter_people_results(Personal.payroll_average_by_titulation)
  end

  def filter_people_results(people)
    people = people.by_modality(params[:modality])  if params[:modality].present?
    people = people.by_department(params[:department]) if params[:department].present?
    people
  end
end
