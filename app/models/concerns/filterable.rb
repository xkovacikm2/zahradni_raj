module Filterable
  extend ActiveSupport::Concern

  module ClassMethods

    def filter_by(params)
      scope = where(nil)

      columns = self.columns.index_by { |c| c.name.to_s }

      if params.present?
        params = params.clone

        params.each do |field, value|
          next if value.blank?

          field = field.to_s

          from_field = field.ends_with?('_from') ? field[0..-6] : nil
          to_field   = field.ends_with?('_to') ? field[0..-4] : nil

          if self.respond_to? "filter_by_#{field}"
            scope = self.send "filter_by_#{field}", scope, value
          elsif columns[field]
            scope = column_condition scope, columns[field], value, '=', params
          elsif from_field && columns[from_field]
            type = columns[from_field].type

            if type == :datetime || type == :date
              type  = :string
              value = Date.parse(value).beginning_of_day
            end

            scope = column_condition scope, columns[from_field], value, '>=', params
          elsif to_field && columns[to_field]
            type = columns[to_field].type

            if type == :datetime || type == :date
              type  = :string
              value = Date.parse(value).end_of_day
            end

            scope = column_condition scope, columns[to_field], value, '<=', params
          end
        end
      end

      scope
    end

    private

    def column_condition(scope, column, value, operator = '=', values = {})
      field    = column.name
      type     = column.type
      name     = table_column_name field
      operator = 'IN' if value.is_a? Array

      if value == 'NULL'
        scope = scope.where("#{name} IS NULL")
      elsif column.array
        value = Array(value).map(&:to_s) if type == :string
        value = Array(value).map(&:to_i) if type == :integer

        scope = scope.where("#{name} && ARRAY[?]", value)
      elsif type == :string || type == :text
        if operator == '='
          scope = multiple_search scope, name, value
        else
          scope = scope.where("#{name} #{operator} (?)", value)
        end
      elsif type == :datetime || type == :date
        scope = scope.where("DATE(#{name}) #{operator} ?", Date.parse(value.to_s))
      elsif type == :boolean
        scope = scope.where("(#{name} = true)") if Utility.yes? value
        scope = scope.where("(#{name} = false OR #{name} IS NULL)") if Utility.no? value
      else
        # :integer, :decimal, :float

        scope = scope.where("#{name} #{operator} (?)", value)
      end

      scope
    end

    def multiple_search(scope, name, values)
      conditions = []
      parameters = []

      values.to_s.split('|').each do |value|
        conditions << "(UNACCENT(#{name}) ILIKE ?)"
        parameters << Utility.clean_like(value)
      end

      scope = scope.where(conditions.join(' OR '), *parameters)

      scope
    end

    def table_column_name(column)
      self.to_s.underscore.gsub('/', '_').pluralize + "." + column
    end
  end
end