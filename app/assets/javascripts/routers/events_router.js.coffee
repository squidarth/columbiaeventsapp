EventSalsa.module "Routing.Events", (EventsRouting, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # Event Bindings
  # --------------
  console.log 'hi'
  EventSalsa.vent.bind "events:show", ->
    EventSalsa.Routing.showRoute "events"

  EventSalsa.vent.bind "events:show:category", (category) ->
    EventSalsa.Routing.showRoute "categories", category.id, "events"

  EventSalsa.vent.bind "events:show:attending", ->
    EventSalsa.Routing.showRoute "attendings", "events"

  EventSalsa.vent.bind "events:calendar:show", ->
    EventSalsa.Routing.showRoute "calendar"

  # Private API
  # -----------
  EventsRouting.Router = Marionette.AppRouter.extend
    appRoutes:
      ""                       : "showEventList"
      "events"                 : "showEventList"
      "categories/:id/events"  : "showEventListByCategoryId"
      "attendings/events"      : "showEventListByAttending"

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    console.log 'bye'
    EventsRouting.router = new EventsRouting.Router
      controller: EventSalsa.EventsApp
