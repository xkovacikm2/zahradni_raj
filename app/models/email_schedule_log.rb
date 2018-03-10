class EmailScheduleLog < ApplicationRecord
  belongs_to :email

  enum status: [:scheduled, :in_progress, :finished]

  default_scope -> () { order created_at: :desc }
end
