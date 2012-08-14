EventSalsa.module 'Pages', (Pages, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  Pages.showAboutPage = ->
    EventSalsa.layout.content.show new EventSalsa.Pages.AboutView()

  Pages.showContactPage = ->
    EventSalsa.layout.content.show new EventSalsa.Pages.ContactView()

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'pages:about:show', ->
    Pages.showAboutPage()
    window.scrollTo 0

  EventSalsa.vent.bind 'pages:contact:show', ->
    Pages.showContactPage()
    window.scrollTo 0

  # Views
  # -----
  class Pages.AboutView extends Marionette.ItemView
    template: JST["templates/pages/about"]

  class Pages.ContactView extends Marionette.ItemView
    template: JST["templates/pages/contact"]
