class RemoveNullConstraintsOnCustomer < ActiveRecord::Migration[5.0]
  def change
    change_column_null :customers, :name, true
    change_column_null :customers, :surname, true
    change_column_null :customers, :address, true
    change_column_null :customers, :email, false
  end
end
