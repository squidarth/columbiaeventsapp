EventSalsa.module 'EventsApp', (EventsApp, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  EventsApp.showEventList = ->
    $.get '/events.json', (data) ->
      EventsApp.upcomingEvents.reset data['upcoming']
      EventsApp.recentEvents.reset data['recent']
      EventsApp.Events.showEvents EventsApp.upcomingEvents, EventsApp.recentEvents

  EventsApp.showEventListByCategoryId = (id) ->
    EventsApp.Events.show EventsApp.events

  # Models
  # ------
  class EventsApp.Event extends Backbone.Model
    paramRoot: 'event'
    urlRoot: '/events'

    defaults:
      name: null
      description: null
      date: null

  class EventsApp.EventCollection extends Backbone.Collection
    model: EventsApp.Event
    url: ->
      @prefix + '/events' + @query

    initialize: (options = {}) ->
      @prefix = options.prefix || ''
      @query = options.query || '/recent'

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'events:show:category', (category) ->
    EventsApp.Events.showEventListByCategoryId category.id

  # Private API
  # -----------
  EventSalsa.addInitializer ->
    EventsApp.upcomingEvents = new EventsApp.EventCollection()
    EventsApp.recentEvents = new EventsApp.EventCollection()
