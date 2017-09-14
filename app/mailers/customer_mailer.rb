class CustomerMailer < ActionMailer::Base
  default from: 'info@zahradniraj.cz'

  def mass_emails(customers = [], content = '', subject = '')
    customers.each do |customer|
      @content = content
      mail(to: customer.email, subject: subject)
    end
  end
end
