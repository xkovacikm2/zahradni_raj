class AddInternalIdToOffer < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :internal_id, :int, unique: true
  end
end
