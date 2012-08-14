EventSalsa.module 'EventsApp', (EventsApp, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  EventsApp.showEventList = ->
    $.get '/events.json', (data) ->
      EventsApp.upcomingEvents.reset data['upcoming']
      EventsApp.recentEvents.reset data['recent']
      EventsApp.Events.showEvents EventsApp.upcomingEvents, EventsApp.recentEvents

  EventsApp.showEventListByCategoryId = (id) ->
    $.get "/categories/#{id}/events.json", (data) ->
      EventsApp.upcomingEvents.reset data['upcoming']
      EventsApp.recentEvents.reset data['recent']
      EventsApp.Events.showEvents EventsApp.upcomingEvents, EventsApp.recentEvents

  # Models
  # ------
  class EventsApp.Event extends Backbone.Model
    paramRoot: 'event'
    urlRoot: '/events'

    defaults:
      name: null
      date: null
    initialize: ->
      # [TODO] Find out why last attendings is undefined
      @attending = new EventsApp.Attendings.Attending
        event_id: @get('id')
      if EventSalsa.currentUser and @get('attendings')
        attendingIndex = $.inArray EventSalsa.currentUser.id, @get('attendings').map (attending) ->
          attending.user.id
        if attendingIndex >= 0
          @attending.set @get('attendings')[attendingIndex]

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
    EventsApp.showEventListByCategoryId category.id

  # Private API
  # -----------
  EventSalsa.addInitializer ->
    EventsApp.upcomingEvents = new EventsApp.EventCollection()
    EventsApp.recentEvents = new EventsApp.EventCollection()
