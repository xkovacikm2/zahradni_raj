# Preview all emails at http://localhost:3000/rails/mailers/customer_mailer
class CustomerMailerPreview < ActionMailer::Preview
  def mass_email_preview
    CustomerMailer.mass_emails
  end
end
