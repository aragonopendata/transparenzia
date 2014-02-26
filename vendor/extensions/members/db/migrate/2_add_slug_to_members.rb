class AddSlugToMembers < ActiveRecord::Migration
    def change
      add_column :refinery_members, :slug, :string
      add_index  :refinery_members, :slug
    end
  end