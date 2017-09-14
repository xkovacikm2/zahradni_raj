class CustomerMailer < ActionMailer::Base
  default from: 'info@zahradniraj.cz'

  def mass_emails(email, content = '', subject = '')
    @content = content
    mail(to: email, subject: subject)
  end
end
