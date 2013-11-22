class AddPayrollToPersonals < ActiveRecord::Migration
  def change
    add_column :personals, :payroll, :string
  end
end
