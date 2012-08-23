EventSalsa.module 'Routing.Pages', (PagesRouting, EventSalsa, Backbone, Marionette, $, _) ->
  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'pages:about:show', ->
    EventSalsa.Routing.showRoute 'about'

  EventSalsa.vent.bind 'pages:contact:show', ->
    EventSalsa.Routing.showRoute 'contact'

  # Private API
  # -----------
  PagesRouting.Router = Marionette.AppRouter.extend
    appRoutes:
      'about': 'showAboutPage'
      'contact': 'showContactPage'

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    PagesRouting.router = new PagesRouting.Router
      controller: EventSalsa.Pages
