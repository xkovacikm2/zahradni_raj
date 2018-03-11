class Email < ApplicationRecord
  include Filterable

  has_many :email_schedule_logs

  default_scope ->(){ order created_at: :desc }

  validates_presence_of :subject, :body

  def sent_to
    self.email_schedule_logs.finished.inject(0){ |sum, log| sum += log.user_ids.count }
  end

  def scheduled_to
    self.email_schedule_logs.scheduled.inject(0){ |sum, log| sum += log.user_ids.count }
  end
end
