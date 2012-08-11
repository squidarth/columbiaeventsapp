EventSalsa.module "Routing.Events", (EventsRouting, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # Private API
  # -----------
  EventsRouting.Router = Marionette.AppRouter.extend
    appRoutes:
      ""                       : "showEventList"
      "events"                 : "showEventList"
      "categories/:id/events"  : "showEventListByCategoryId"

  # Event Bindings
  # --------------
  EventSalsa.vent.bind "events:show", ->
    EventSalsa.Routing.showRoute "events"

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventsRouting.router = new EventsRouting.Router
      controller: EventSalsa.EventsApp
