# This migration comes from refinery_authentication (originally 20130805143059)
class AddFullNameToRefineryUsers < ActiveRecord::Migration
  def change
    add_column :refinery_users, :full_name, :string
  end
end
