class Personal < ActiveRecord::Base
 attr_accessible :code, :sex, :sex_description, :age, :titulation, :titulation_description, :modality, 
    :modality_description, :department, :department_description, :subdivision, :subdivision_description, 
    :group, :group_description, :area, :area_description, :contrato, :contract_class_description, 
    :group_contribution, :group_contribution_key, :mutualiadad_administrativa, :GR_COT_Conjunto,
    :triennia, :payroll

    def self.payroll_average_by_place
      select("avg(payroll) as total_payroll, subdivision_description").group("subdivision_description")
    end

    def self.payroll_average_by_department
      select("avg(payroll) as total_payroll, department_description").group("department_description")
    end

    def self.payroll_average_by_titulation
      select("avg(payroll) as total_payroll, titulation_description").group("titulation_description")
    end
end
