class AddCustomerStatusToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_reference :customers, :customer_status, foreign_key: true
  end
end
