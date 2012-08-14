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
    window.scrollTo 0
    Pages.showAboutPage()

  EventSalsa.vent.bind 'pages:contact:show', ->
    window.scrollTo 0
    Pages.showContactPage()

  # Views
  # -----
  class Pages.AboutView extends Marionette.ItemView
    template: JST["templates/pages/about"]

  class Pages.ContactView extends Marionette.ItemView
    template: JST["templates/pages/contact"]
