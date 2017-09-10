class App.Customers extends App.Base
  new: =>
    @create()

  edit: =>
    @create()

  update: =>
    @create()

  create: =>
    Utility.Utility.entangle_selects "customer_country_id", "customer_region_id", "countries"

  write_emails: =>
    $('.wysihtml5').wysihtml5(
      {
        toolbar:
          fa: true
          html: true
          color: true
        locale: 'cs-CZ'
      }
    )
