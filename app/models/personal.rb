class Personal < ActiveRecord::Base

    scope :by_modality, -> (modality) { where(modality_description: modality)}
    scope :by_department, -> (department) { where(department_description: department) }

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
