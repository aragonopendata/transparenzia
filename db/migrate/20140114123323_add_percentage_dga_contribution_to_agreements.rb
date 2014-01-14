class AddPercentageDgaContributionToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :dga_contribution_percentage, :decimal
  end
end
