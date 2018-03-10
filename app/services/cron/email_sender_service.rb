module Cron::EmailSenderService
  extend self

  def send_scheduled
    schedule = EmailScheduleLog.scheduled.first
    schedule.in_progress!

    customers = Customer.where(id: schedule.user_ids)

    customers.each do |customer|
      CustomerMailer.mass_emails(customer.email, schedule.email.body, schedule.email.subject).deliver_now
    end

    schedule.finished
  end
end