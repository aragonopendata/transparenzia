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

  MODALIDADES = [ "A disposición del Consejero", 
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

  def modalidades
    MODALIDADES
  end
end
