class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.date :date
      t.references :customer, foreign_key: true, index: true
      t.integer :request_categories, foreign_key: true, array: true, default: []

      t.timestamps
    end
  end
end
