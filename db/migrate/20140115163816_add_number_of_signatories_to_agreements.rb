class AddNumberOfSignatoriesToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :number_of_signatories, :integer
  end
end
