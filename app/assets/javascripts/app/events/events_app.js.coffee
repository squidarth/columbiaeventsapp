EventSalsa.module 'EventsApp', (EventsApp, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  EventsApp.showEventList = ->
    EventsApp.currentEventSource = '/events.json'
    resetEventCollections()
    fetchEvents()

  EventsApp.showEventListByCategoryId = (id) ->
    EventsApp.currentEventSource = "/categories/#{id}/events.json"
    resetEventCollections()
    fetchEvents()

  EventsApp.showMoreEvents = ->
    EventsApp.currentPageCount += 1
    fetchEvents()

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'events:show', ->
    window.scrollTo 0
    EventsApp.showEventList()

  EventSalsa.vent.bind 'events:show:category', (category) ->
    window.scrollTo 0
    EventsApp.showEventListByCategoryId category.id

  EventSalsa.vent.bind 'events:more:upcoming', ->
    if EventsApp.upcomingEvents.isReadyToFetch()
      EventsApp.showMoreEvents()

  EventSalsa.vent.bind 'events:more:recent', ->
    if EventsApp.recentEvents.isReadyToFetch()
      EventsApp.showMoreEvents()

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
    url: '/events'
    isReadyToFetch: ->
      return not @loading and @length < @totalLength

  # Private API
  # -----------
  resetEventCollections = ->
    EventsApp.currentPageCount = 1
    EventsApp.upcomingEvents.reset()
    EventsApp.recentEvents.reset()

  fetchEvents = ->
    EventsApp.upcomingEvents.loading = yes
    EventsApp.recentEvents.loading = yes
    $.getJSON EventsApp.currentEventSource, { page: EventsApp.currentPageCount }, (data) ->
      EventsApp.upcomingEvents.add data['record']['upcoming']
      EventsApp.upcomingEvents.totalLength = data['upcoming_count']
      EventsApp.recentEvents.add data['record']['recent']
      EventsApp.recentEvents.totalLength = data['recent_count']
      EventsApp.upcomingEvents.loading = no
      EventsApp.recentEvents.loading = no
      EventsApp.Events.showEvents EventsApp.upcomingEvents, EventsApp.recentEvents

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventsApp.upcomingEvents = new EventsApp.EventCollection()
    EventsApp.recentEvents = new EventsApp.EventCollection()
