class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.string :code
      t.integer :year
      t.string :section
      t.text :title
      t.date :agreement_date
      t.date :signature_date
      t.date :validity_date
      t.string :signatories
      t.string :dga_contribution
      t.string :another_contributions
      t.string :amount
      t.string :addendums
      t.text :observations
      t.text :notes
      t.string :pdf_url

      t.timestamps
    end
  end
end
