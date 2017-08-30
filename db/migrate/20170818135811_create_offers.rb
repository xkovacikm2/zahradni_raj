class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.date :date
      t.references :request, foreign_key: true, null: false

      t.timestamps
    end
  end
end
