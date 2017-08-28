class CreateCustomerStatus < ActiveRecord::Migration[5.0]
  def change
    create_table :customer_statuses do |t|
      t.string :name, null: false, index: true
    end
  end
end
