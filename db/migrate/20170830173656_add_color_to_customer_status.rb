class AddColorToCustomerStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :customer_statuses, :color, :string
  end
end
