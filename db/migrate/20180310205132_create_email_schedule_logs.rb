class CreateEmailScheduleLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :email_schedule_logs do |t|
      t.integer :user_ids, array: true, default: []
      t.belongs_to :email, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
