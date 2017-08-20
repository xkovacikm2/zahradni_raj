module Utility
  extend self

  def yes?(value)
    value = value.to_s.downcase

    value == 'yes' || value == '1' || value == 1 || value == true || value == 'true' || value == 'y' || value == 't'
  end

  def no?(value)
    value = value.to_s.downcase

    value == 'no' || value == '0' || value == 0 || value == false || value == 'false' || value == 'n' || value == 'f'
  end

  # Prepare value for LIKE query
  def clean_like(value)
    value.gsub('*', '%').gsub('_', '\\_')
  end

  # Perform (date1 - date2) operation on dates. If date is empty, returns 0
  def date_diff(date1, date2)
    return 0 if date1.blank? || date2.blank?

    date1 = Date.parse(date1.to_s) if date1.is_a? String
    date2 = Date.parse(date2.to_s) if date2.is_a? String

    (date1.to_date - date2.to_date).abs.to_i
  end

  # Perform (date1 - date2) operation on dates. If date is empty, returns 0
  def date_diff_months(date1, date2)
    return 0 if date1.blank? || date2.blank?

    date1 = Date.parse(date1.to_s) if date1.is_a? String
    date2 = Date.parse(date2.to_s) if date2.is_a? String

    date1 = date1.to_date
    date2 = date2.to_date

    ((date1.year * 12 + date1.month) - (date2.year * 12 + date2.month)).abs
  end

  def controllers
    list = Dir[Rails.root.join('app/controllers/**/*_controller.rb')].map { |path| path.match(/app\/controllers\/(.*).rb/); $1 }.compact
    list.map { |name| name.classify.constantize }
  end

  # Tries to find model for given column and most appropriate value
  def resource_to_value(reference_column, value, display_column = nil, join_by = ', ')
    model = reference_column.gsub(/_id$/, '').classify.safe_constantize

    begin
      records        = model.where(id: value) # this works also if value is an array
      guessed_column = (%w(representative_name code name label number username iban) & model.columns.map(&:name)).first

      return records.map { |record| display_column ? record.try(display_column) : record.try(guessed_column) }.join(join_by)
    rescue
      return value unless value.is_a? Array
      return value.join(', ') if value.is_a? Array
    end
  end

  def model_from_input_name(input_name)
    return input_name.match(/\[(.*)\]/).captures[0][0..-4] if input_name.scan(']').count == 1

    input_name = input_name.split(']')[-1].gsub('[', '')
    input_name.gsub('_id', '')
  end

  def monetary_two_decimals(number)
    number.round(2, half: :down)
  end

  def floor_to_two_decimals(number)
    ((number) * 100).floor / BigDecimal.new(100)
  end

  def model_class_from_controller(class_name)
    name      = Utility.permission_name_from_controller(class_name).split('/').last.singularize
    namespace = Utility.permission_name_from_controller(class_name).split('/')[0..-2]

    namespaced_name = [namespace, name].join('/').singularize.camelize.safe_constantize || name

    namespaced_name.to_s.camelize.safe_constantize
  end

  def permission_name_from_controller(class_name)
    class_name[0..-11].underscore
  end
end