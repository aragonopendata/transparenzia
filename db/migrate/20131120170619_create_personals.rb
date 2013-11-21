class CreatePersonals < ActiveRecord::Migration
  def change
    create_table :personals do |t|
      t.integer :code 
      t.integer :sex
      t.string  :sex_description
      t.integer :age
      t.string  :titulation
      t.string  :titulation_description
      t.string  :modality
      t.string  :modality_description
      t.string  :department
      t.string  :department_description
      t.string  :subdivision
      t.string  :subdivision_description
      t.string  :group
      t.string  :group_description
      t.string  :area
      t.string  :area_description
      t.string  :contract_class
      t.string  :contract_class_description
      t.integer :group_contribution
      t.string  :group_contribution_key 
      t.string  :mutualiadad_administrativa
      t.string  :gr_cot_conjunto
      t.integer :triennia

      t.timestamps
    end
  end
end