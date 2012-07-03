class EventSalsa.Routers.EventsRouter extends Backbone.Router
  initialize: (options) ->
    @upcomingEvents = new EventSalsa.Collections.EventsCollection
      query: '/upcoming'
    @recentEvents = new EventSalsa.Collections.EventsCollection
    # TODO refactor fetch
    @upcomingEvents.fetch()
    @recentEvents.fetch()

  routes:
    ""                 : "indexUpcomingEvents"
    "events"           : "indexUpcomingEvents"
    "events/new"       : "newEvent"
    "events/upcoming"  : "indexUpcomingEvents"
    "events/recent"    : "indexRecentEvents"
    "events/:id/edit"  : "edit"
    "events/:id"       : "show"

  newEvent: ->
    @view = new EventSalsa.Views.Events.NewView(collection: @upcomingEvents)
    $("#events").html(@view.render().el)

  indexUpcomingEvents: ->
    @view = new EventSalsa.Views.Events.IndexView(events: @upcomingEvents)
    $("#events").html(@view.render().el)

  indexRecentEvents: ->
    @view = new EventSalsa.Views.Events.IndexView(events: @recentEvents)
    $("#events").html(@view.render().el)

  show: (id) ->
    event = @upcomingEvents.get(id)

    @view = new EventSalsa.Views.Events.ShowView(model: event)
    $("#event").html(@view.render().el)

  edit: (id) ->
    event = @upcomingEvents.get(id)

    @view = new EventSalsa.Views.Events.EditView(model: event)
    $("#events").html(@view.render().el)
