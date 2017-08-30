class AddContactDateToOffer < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :contact_date, :date
  end
end
