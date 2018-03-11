module Cron::EmailSenderService
  extend self

  def send_scheduled
    schedule = EmailScheduleLog.scheduled.first
    return if schedule.nil?

    schedule.in_progress!
    schedule.save

    customers = Customer.where(id: schedule.user_ids)

    customers.each do |customer|
      CustomerMailer.mass_emails(customer.email, schedule.email.body, schedule.email.subject).deliver_now
    end

    schedule.finished!
    schedule.save
  end
end
