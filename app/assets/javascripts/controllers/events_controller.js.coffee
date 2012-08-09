EventSalsa.module 'EventsController', (EventsController, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  EventsController.showEventList = ->
    EventsController.Events.show EventsController.events

  # Models
  # ------
  class EventSalsa.EventsController.Event extends Backbone.Model
    paramRoot: 'event'
    urlRoot: '/events'

    defaults:
      name: null
      description: null
      date: null

  class EventSalsa.EventsController.EventCollection extends Backbone.Collection
    model: EventsController.Event
    url: ->
      @rootPath + '/events' + @query

    init: (options = {}) ->
      @prefix = options.prefix || ''
      @query = options.query || '/recent'

  # Private API
  # -----------

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventsController.events = new EventsController.EventCollection()
    EventsController.events.fetch()
