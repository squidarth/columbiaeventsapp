EventSalsa.module 'Routing.Events', (EventsRouting, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'events:show', ->
    EventSalsa.Routing.showRoute 'events'

  EventSalsa.vent.bind 'events:show:category', (category) ->
    EventSalsa.Routing.showRoute 'categories', category.id, 'events'

  EventSalsa.vent.bind 'events:show:attending', (user_id) ->
    EventSalsa.Routing.showRoute 'users', user_id, 'attendings'

  EventSalsa.vent.bind 'events:show:managing', (user_id) ->
    EventSalsa.Routing.showRoute 'users', user_id, 'events'

  EventSalsa.vent.bind 'events:calendar:show', ->
    EventSalsa.Routing.showRoute 'calendar'

  # Private API
  # -----------
  EventsRouting.Router = Marionette.AppRouter.extend
    appRoutes:
      ''                           : 'showEventList'
      'events'                     : 'showEventList'
      'categories/:id/events'      : 'showEventListByCategoryId'
      'users/:user_id/attendings'  : 'showEventListByAttending'
      'users/:user_id/events'      : 'showEventListByManaging'

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventsRouting.router = new EventsRouting.Router
      controller: EventSalsa.EventsApp
