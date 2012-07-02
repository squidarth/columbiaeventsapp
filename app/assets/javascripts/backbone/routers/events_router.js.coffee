class EventSalsa.Routers.EventsRouter extends Backbone.Router
  initialize: (options) ->
    @events = new EventSalsa.Collections.EventsCollection
    @events.fetch()

  routes:
    ""                 : "index"
    "events"           : "index"
    "events/new"       : "newEvent"
    "events/index"     : "index"
    "events/:id/edit"  : "edit"
    "events/:id"       : "show"

  newEvent: ->
    @view = new EventSalsa.Views.Events.NewView(collection: @events)
    $("#events").html(@view.render().el)

  index: ->
    @view = new EventSalsa.Views.Events.IndexView(events: @events)
    $("#events").html(@view.render().el)

  show: (id) ->
    event = @events.get(id)

    @view = new EventSalsa.Views.Events.ShowView(model: event)
    $("#event").html(@view.render().el)

  edit: (id) ->
    event = @events.get(id)

    @view = new EventSalsa.Views.Events.EditView(model: event)
    $("#events").html(@view.render().el)
