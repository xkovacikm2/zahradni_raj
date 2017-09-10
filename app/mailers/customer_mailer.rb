class CustomerMailer < ActionMailer::Base
  default from: 'info@zahradniraj.cz'

  def mass_emails(users = nil, content = '', subject = '')
    @content = content
    mail(to: 'xkovacikm2@gmail.com', subject: subject)
  end
end
