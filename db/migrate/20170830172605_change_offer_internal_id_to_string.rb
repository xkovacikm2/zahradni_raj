class ChangeOfferInternalIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :offers, :internal_id, :string
  end
end
