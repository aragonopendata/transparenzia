class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name
      t.string :district
      t.string :province

      t.timestamps
    end
  end
end
