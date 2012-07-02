class EventSalsa.Routers.CategoriesRouter extends Backbone.Router
  initialize: (options) ->
    @categories = new EventSalsa.Collections.CategoriesCollection()
    @categories.fetch
      success: => @index()

  routes:
    "categories/index"       : "index"
    "categories/:id/events"  : "events"

  index: ->
    @view = new EventSalsa.Views.Categories.IndexView(categories: @categories)
    $("#categories").html(@view.render().el)

  events: (id) ->
    @events ||= {}
    @events[id] ||= new EventSalsa.Collections.EventsCollection
      rootPath: "/categories/#{id}/events"
      query: '/recent'
    @events[id].fetch
      success: =>
        @view = new EventSalsa.Views.Events.IndexView(events: @events[id])
        $("#events").html(@view.render().el)
