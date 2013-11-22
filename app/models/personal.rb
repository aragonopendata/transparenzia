class Personal < ActiveRecord::Base
 attr_accessible :code, :sex, :sex_description, :age, :titulation, :titulation_description, :modality, 
    :modality_description, :department, :department_description, :subdivision, :subdivision_description, 
    :group, :group_description, :area, :area_description, :contrato, :contract_class_description, 
    :group_contribution, :group_contribution_key, :mutualiadad_administrativa, :GR_COT_Conjunto,
    :triennia, :payroll
end
