require Rails.root.join 'app', 'services', 'email_sender_service'

namespace :emails do

  task :send do
    EmailSenderService.send_scheduled
  end

end
