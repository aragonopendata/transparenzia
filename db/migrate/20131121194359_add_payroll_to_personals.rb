class AddPayrollToPersonals < ActiveRecord::Migration
  def change
    add_column :personals, :payroll, :decimal
  end
end
