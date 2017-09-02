module FilterHelper
  def search_form(model, fields = {}, options = {})
    options[:advanced_search] ||= 50

    html = '<div class="clearfix"></div><div class="filter"><form method="get" class="form-horizontal">'

    html << build_inputs(model, fields, options)

    html << '<div class="form-group">' # Button form group

    # Search button
    html << '<div class="col-md-offset-2 col-md-4">'
    html << '<button class="btn btn-sm btn-primary btn-block">'
    html << '<i class="fa fa-search"></i>' + ' ' + t('views.forms.search')
    html << '</button>'
    html << '</div>'

    # Clear search form button
    html << '<div class="col-md-offset-2 col-md-4">'
    html << link_to(nil, class: 'btn btn-sm btn-default btn-block') do
      '<i class="fa fa-ban"></i>'.html_safe + ' ' + t('views.forms.clear_search')
    end
    html << '</div>'

    html << '</div>' # Button form group

    html << '</form></div><div class="clearfix"></div>'

    html.html_safe
  end

  def transaction_filter(fields, options = {})
    options[:advanced_search] = 500

    model = options[:model] || Transaction

    build_inputs(Transaction, fields, options).html_safe
  end

  def search_options(model, display_field = nil, id_field = :id, scope = nil)
    columns       = model_columns model
    model         = model.send(scope) if scope

    display_field ||= :code if columns[:code]
    display_field ||= :name if columns[:name]
    display_field ||= :label if columns[:label]
    display_field ||= :email if columns[:email]
    display_field ||= :id

    id_field ||= :id

    display_field = display_field.to_s
    id_field      = id_field.to_s

    model.all.limit(200).map do |item|
      [item.send(display_field), item.send(id_field)]
    end
  end

  private

  def build_inputs(model, fields, options)
    counter = 0
    in_advanced_section = false
    html = ''

    fields.each do |field, user_options|

      if field == :hr && user_options == :hr
        if counter % 2 == 1
          html << '</div>'
          counter += 1
        end

        html << '<hr/>'
        next
      end

      if !in_advanced_section && counter >= options[:advanced_search] * 2
        in_advanced_section = true
        is_advanced_search  = params['advanced_search']

        html << '<div class="form-group" style="display:' + (is_advanced_search ? 'none' : 'block') +'">'
        html << '<div class="col-sm-offset-8 col-sm-4">'
        html << '<a href="#" id="advanced-search-button">' + t('views.forms.advanced_search') + '</a>'
        html << '</div>'
        html << '</div>'
        html << '<div id="advanced-search" style="display:' + (is_advanced_search ? 'block' : 'none') + '">'

        html << '<input type="hidden" name="advanced_search" value="yes">' if is_advanced_search
      end


      field_options = field_options(model, field, options[:values] || params[:filter], user_options)

      html << '<div class="form-group">' if counter % 2 == 0

      html << '<label class="col-sm-2 control-label">'
      html << field_options[:label]
      html << '</label>'

      html << '<div class="col-sm-4">'
      html << input_field_tag(model, field, field_options, options)
      html << '</div>'

      html << '</div>' if counter % 2 == 1

      counter += 1
    end

    html << '</div>' if counter % 2 == 1 # End the form-group block if odd number of fields

    html << '</div>' if in_advanced_section

    html
  end

  def input_field_tag(model, field, options, helper_options)
    filter_name = helper_options[:filter_name] || 'filter'
    name        = "#{filter_name}[#{field.to_s}]"
    name_from   = "#{filter_name}[#{field.to_s}_from]"
    name_to     = "#{filter_name}[#{field.to_s}_to]"

    tag_options            = {}
    tag_options[:multiple] = true if options[:multiple]
    tag_options[:class]    = options[:class] + ' input-sm'
    tag_options[:data]     = options[:data] || {}


    if options[:type] == :select
      select_tag name, options_for_select(options[:options], options[:value]), tag_options
    elsif options[:type] == :group_select
      select_tag name, grouped_options_for_select(options[:options], options[:value]), tag_options
    elsif options[:type] == :boolean
      value   = nil
      value   = 'yes' if Utility.yes? options[:value]
      value   = 'no' if Utility.no? options[:value]
      options = {t('all') => nil, t('yes') => 'yes', t('no') => 'no'}

      select_tag name, options_for_select(options, value), tag_options
    elsif options[:type] == :checkbox
      checked   = options[:value] || false

      check_box_tag name, '1', checked, tag_options
    else
      tag_options[:class]           += ' form-control'
      tag_options[:data][:provider] = :datepicker if options[:type] == :date

      if options[:from_to]
        html = '<div class="input-group" style="width: 100%">'
        html << text_field_tag(name_from, options[:value_from], tag_options.merge({placeholder: options[:label] + ' from'}))
        html << '<div class="input-group-btn" style="width: 50%">'
        html << text_field_tag(name_to, options[:value_to], tag_options.merge({placeholder: options[:label] + ' to'}))
        html << '</div></div>'
        html
      else
        html = ''
        html << '<div class="input-group">' if options[:list]
        html << text_field_tag(name, options[:value], tag_options)

        if options[:list]
          html << '<span class="input-group-btn"><span  class="btn btn-default btn-sm search-listable" title="' + t('views.forms.list_values') + '"><i class="fa fa-list"></i></span></span>'
          html << '</div>'
        end

        html
      end
    end
  end

  def field_options(model, field, values, options)
    column      = column_details model, field
    association = association_details model, field

    if column && (column.type == :datetime || column.type == :date)
      options[:type] ||= :date
    end

    if association
      options[:type]    ||= :select
      options[:options] ||= default_options association.klass
    end

    if options[:options].blank? && options[:unique_options]
      options[:options] = model.distinct(field).select(field).order(field).map { |row| row[field] }
    end

    options[:label]    ||= model.human_attribute_name field
    options[:type]     ||= options[:options].present? ? :select : :text
    options[:value]    ||= values ? values[field.to_s] : options[:default_value]
    options[:class]    ||= ''
    options[:multiple] = true if options[:multiple].nil? && options[:type] == :select

    if options[:from_to]
      options[:value_from] ||= values ? values["#{field}_from"] : options[:default_value_from]
      options[:value_to]   ||= values ? values["#{field}_to"] : options[:default_value_to]
    end

    if options[:multiple].blank? && options[:options].present?
      options[:options] = options[:options].insert(0, '')
    end

    options
  end

  def default_options(model)
    search_options model
  end

  def column_details(model, name)
    columns = model_columns model

    columns[name.to_sym]
  end

  def association_details(model, name)
    associations = model_associations model

    associations[name.to_sym]
  end

  def model_columns(model)
    name_sym = model.name.underscore.to_sym

    @@cached_model_columns           = {}
    @@cached_model_columns[name_sym] ||= model.columns.index_by { |c| c.name.to_sym }

    @@cached_model_columns[name_sym]
  end

  def model_associations(model)
    name_sym = model.name.underscore.to_sym

    @@cached_model_associations           = {}
    @@cached_model_associations[name_sym] ||= model.reflect_on_all_associations(:belongs_to).index_by { |a| a.foreign_key.to_sym }
  end
end