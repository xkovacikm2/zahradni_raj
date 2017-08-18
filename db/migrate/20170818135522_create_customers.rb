class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :company
      t.string :ico
      t.string :dic
      t.string :address, null: false
      t.string :email
      t.string :phone
      t.text :note
      t.references :recruitment_center, foreign_key: true, index: true
      t.references :country, foreign_key: true
      t.references :region, foreign_key: true, index: true

      t.timestamps
    end
  end
end
