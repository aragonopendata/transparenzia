require 'csv'

class PersonalImporter
  attr_accessor :keys, :data
  def initialize(text, payroll_text="")
    initialize_payroll(payroll_text)

    csv = CSV.parse(text.delete('#'))
    @keys = csv.shift
    @data = csv.collect{ |line|
      item = {}
      @keys.each_index { |key_index|
        column = @keys[key_index]
        item[column] = line[key_index]
      }

      if @payroll_hash
        item = add_payroll(item)
      else
        item
      end
    }
  end

  def save
    Personal.delete_all
    @data.each do |item|
      puts item['Nº pers']
      person = Personal.create(
          :code => item['Nº pers'],
          :sex => item['Sexo'],
          :sex_key => item['Clave de sexo'],
          :age => item['Edad del empleado'],
          :titulation => item['GR_Titulac'],
          :titulation_description => item['Desc_GR_titulac'],
          :modality => item['Modalidad'],
          :modality_description => item['Desc Modalidad'],
          :department => item['DivP'],
          :department_description => item['División de personal'],
          :subdivision => item['SubPer'],
          :subdivision_description => item['Subdivisión de personal'],
          :group => item['GrPer'],
          :group_description => item['Grupo de personal'],
          :area => item['ÁPers'],
          :area_description => item['Área de personal'],
          :contrato => item['CC'],
          :contract_class_description => item['Clase de contrato'],
          :group_contribution => item['GrCot'],
          :group_contribution_key => item['Clave del grupo de cotización'],
          :mutualiadad_administrativa => item['Mutualidad Administrativa'],
          :GR_COT_Conjunto => item['GR_COT_Conjunto'],
          :triennia => item['Trienios_nomina'],
          :payroll => item['Bruto perc']
        )
      puts person.code
    end
    #Personal.create persons
  end

  private 
    def initialize_payroll(payroll_text)
      @payroll_hash = nil
      if payroll_text!=""
        payroll_csv = CSV.parse(payroll_text)
        @payroll_descriptor = payroll_csv.shift[1]
        @payroll_hash = Hash[payroll_csv]
      end
    end
    def add_payroll(item)
      payroll = @payroll_hash[item['Nº pers']]
      if payroll==nil 
        item[@payroll_descriptor] = 0 
      else
        item[@payroll_descriptor] = payroll
      end
      item
    end
end