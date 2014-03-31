module ApplicationHelper
  PROVINCES = %w(Huesca Teruel Zaragoza)
  DISTRICTS = {
    "Huesca" => [
      "Alto Gállego",
      "Bajo Cinca / Baix Cinca",
      "Cinca Medio",
      "Hoya de Huesca / Plana de Uesca",
      "La Jacetania",
      "La Litera / La Llitera",
      "La Ribagorza",
      "Los Monegros",
      "Sobrarbe",
      "Somontano de Barbastro"
    ],
    "Teruel" => [                   
      "Andorra-Sierra de Arcos",
      "Bajo Aragón",
      "Bajo Martín",
      "Cuencas Mineras",
      "Comunidad de Teruel",
      "Gúdar-Javalambre",
      "Jiloca",
      "Maestrazgo",
      "Matarraña / Matarranya",
      "Sierra de Albarracín",
    ],
    "Zaragoza" => [
      "Aranda",    
      "Bajo Aragón-Caspe / Baix Aragó-Casp",
      "Campo de Belchite",
      "Campo de Borja",
      "Campo de Cariñena",
      "Campo de Daroca",
      "Cinco Villas",
      "Comunidad de Calatayud",
      "DC Zaragoza",
      "Ribera Alta del Ebro",
      "Ribera Baja del Ebro",
      "Tarazona y el Moncayo",
      "Valdejalón"
    ]
  }
  
  def districts(province=nil)
    if province
      distr = DISTRICTS[province]
    else
      distr = DISTRICTS.collect{|k, v| v}.flatten
    end
    distr
  end

  def provinces
    PROVINCES
  end

  def average(arr)
    if arr.size == 0
      0
    else
      arr.inject{ |sum, el| sum + el }.to_i / arr.size
    end
  end

  def navigation_menu
    unless @menu
      @menu = Refinery::Page.in_menu.where(:parent_id => nil).order(:lft)
    end
    @menu
  end
end
