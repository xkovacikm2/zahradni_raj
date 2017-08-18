class CreateRecruitmentCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :recruitment_centers do |t|
      t.string :name, index: true, null: false
    end
  end
end
