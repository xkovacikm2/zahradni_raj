namespace :emails do

  task :send do
    Cron::EmailSenderService.send_scheduled
  end

end
