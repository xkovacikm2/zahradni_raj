class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.string :name, index: true
      t.references :country, index: true
    end
  end
end
