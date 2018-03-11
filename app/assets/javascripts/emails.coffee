class App.Emails extends App.Base

  new: =>
    @init_wysiwyg()

  init_wysiwyg: =>
    $('.wysihtml5').wysihtml5(
      {
        toolbar:
          fa: true
          html: true
          color: true
        locale: 'cs-CZ'
      }
    )
