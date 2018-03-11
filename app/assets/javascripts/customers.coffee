class App.Customers extends App.Base
  new: =>
    @create()

  edit: =>
    @create()

  update: =>
    @create()

  create: =>
    Utility.Utility.entangle_selects "customer_country_id", "customer_region_id", "countries"
