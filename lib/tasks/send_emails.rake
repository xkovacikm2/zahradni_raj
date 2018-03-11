require Rails.root.join 'app', 'services', 'cron', 'email_sender_service'

namespace :emails do

  task :send do
    Cron::EmailSenderService.send_scheduled
  end

end
