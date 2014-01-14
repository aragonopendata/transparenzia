class AddTotalSummationsToAgreement < ActiveRecord::Migration
  def change
    add_column :agreements, :total_amount, :decimal
    add_column :agreements, :total_dga_contribution, :decimal
  end
end
