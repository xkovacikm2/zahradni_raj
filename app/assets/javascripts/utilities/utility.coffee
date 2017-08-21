window.Utility ||= {}

class Utility.Utility
  @entangle_selects: (source, destination, data) ->
    that = @
    $("##{source}").on 'change input', (e) ->
      that.on_entagle(source, destination, data)
    @on_entagle(source, destination, data)

  @on_entagle: (source, destination, data) ->
    $destination = $("##{destination}")
    source_val = $("##{source}").val()
    values = $destination.data(data)

    html_value = ''
    values[source_val].forEach((e) -> html_value += "<option value='#{e["id"]}'>#{e["text"]}</option>") if values?
    $destination.html html_value

  @initInputs: () ->
    @initDatepicker()
    @initSelect()

  @initDatepicker: (scope = document) ->
    $(scope).find('[data-provider=datepicker]').datepicker {
      format: 'yyyy-mm-dd'
      todayHighlight: true
      autoclose: true,
      weekStart: 1,
      orientation: 'bottom'
    }

  @initSelect: (scope = document) ->
    $(scope).find('select:not(.no-select2):not(.select2-hidden-accessible)').select2 {
      theme: 'bootstrap'
      allowClear: true
      placeholder: 'Select an option'
      width: '100%'
    }
