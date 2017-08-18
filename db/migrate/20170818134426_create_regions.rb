class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.string :name, index: true, null: false
      t.references :country, index: true, null: false
    end
  end
end
