class CreateRequestCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :request_categories do |t|
      t.string :name, index: true, null: false
    end
  end
end
