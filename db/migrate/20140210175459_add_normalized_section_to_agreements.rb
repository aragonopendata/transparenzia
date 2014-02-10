class AddNormalizedSectionToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :normalized_section, :integer
  end
end
