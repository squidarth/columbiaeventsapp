EventSalsa.module 'EventsApp', (EventsApp, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  EventsApp.showEventList = ->
    EventsApp.Events.show EventsApp.events

  EventsApp.showEventListByCategory = (id) ->
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

  # Private API
  # -----------

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventsApp.events = new EventsApp.EventCollection()
    EventsApp.events.fetch()
