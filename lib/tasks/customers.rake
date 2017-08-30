require 'csv'

namespace :customers do
  task import_csv: :environment do
    CSV.parse(File.read(Rails.root.join('lib', 'clients.csv')), headers: true, col_sep: ';').each do |row|
      customer = Customer.new

      if row[1].present?
        state = CustomerStatus.find_or_create_by name: row[1]
        customer.customer_status = state
      end

      customer.surname = row[2]
      customer.name = row[3]

      if row[4].present?
        country = Country.find_or_create_by name: row[4]
        customer.country = country
      end

      if row[5].present?
        region = Region.find_or_create_by name: row[5]
        customer.region = region
      end

      customer.address = row[6]
      customer.email = row[7]
      customer.phone = row[8]
      customer.note = row[15]

      if row[9].present?
        center = RecruitmentCenter.find_or_create_by name: row[9]
        customer.recruitment_center = center
      end

      next unless customer.save

      request = customer.requests.new
      request.request_categories = []

      (row[10] || '').split(',').each do |category|
        request_category = RequestCategory.find_or_create_by name: category
        request.request_categories << request_category.id
      end

      request.date = Date.strptime row[12], '%m/%d/%Y' unless row[12].nil?
      request.save

      offer = request.build_offer
      offer.internal_id = row[11]
      offer.date = Date.strptime row[13], '%m/%d/%Y' unless row[13].nil?
      offer.contact_date = Date.strptime row[14], '%m/%d/%Y' unless row[14].nil?
      offer.save
    end
  end
end