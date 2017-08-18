class CreateOfferFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_files do |t|
      t.string :stored_filename
      t.string :extension
      t.string :original_filename
      t.references :offer, foreign_key: true, index: true

      t.timestamps
    end
  end
end
