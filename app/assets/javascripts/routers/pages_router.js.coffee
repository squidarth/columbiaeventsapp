EventSalsa.module "Routing.Pages", (PagesRouting, EventSalsa, Backbone, Marionette, $, _) ->
  # Event Bindings
  # --------------

  # Private API
  # -----------
  PagesRouting.Router = Marionette.AppRouter.extend
    appRoutes:
      "about": "showAboutPage"
      "contact": "showContactPage"

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    PagesRouting.router = new PagesRouting.Router
      controller: EventSalsa.Pages
