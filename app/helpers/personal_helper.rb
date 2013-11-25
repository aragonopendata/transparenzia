module PersonalHelper
  MODALITIES = [ "A disposición del Consejero", 
                "Comisión de Servicios dentro de Aragón",
                "Desempeño conjunto",
                "Desempeño temporal puesto",
                "Destino Definitivo",
                "Destino Provisional",
                "Destino puesto de personal docente ó estatutario",
                "Destino Puesto Gestión",
                "Destino Sustitucion",
                "Docente ó estatutario de la CA que va a un puesto",
                "En comisión de servicios",
                "En prácticas",
                "Fin de periodo ocupacional",
                "Fin licencia por estudios",
                "Inicio periodo ocupacional",
                "Licencia por estudios",
                "no $ hasta T.Pos",
                "Para otra Admón. Pública",
                "Promoción interna temporal",
                "Reingreso provisional",
                "Retribuciones Fun/Lab",
  ]
  
  def modalities
    MODALITIES
  end

  def highest_payroll(people)
    people.max_by{|person| person.payroll}.payroll
  end
  def lowest_payroll(people)
    people.min_by{|person| person.payroll}.payroll
  end
  def payroll_average(people)
    payrolls = @people.collect{|person| person.payroll}
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
    people.count{|person| person.sex==1}
  end
  def number_of_women(people)
    people.count{|person| person.sex==2}
  end
end
