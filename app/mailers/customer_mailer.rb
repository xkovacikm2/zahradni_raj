class CustomerMailer < ActionMailer::Base
  default from: 'info@zahradniraj.cz'

  def mass_emails(filter = {}, content = '', subject = '')
    customers = Customer.filter_by(filter)
    Logger.log customers.map(&:emails).join(', ')
    @content = content

    customers.each do |customer|
      begin
        mail(to: customer.email, subject: subject)
      rescue Exception => e
        Logger.log e
      end
    end
  end
end
