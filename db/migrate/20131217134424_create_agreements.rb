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
      t.text :signatories
      t.text :dga_contribution
      t.text :another_contributions
      t.text :amount
      t.text :addendums
      t.text :observations
      t.text :notes
      t.text :pdf_url

      t.timestamps
    end
  end
end
