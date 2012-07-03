class EventSalsa.Routers.CategoriesRouter extends Backbone.Router
  initialize: (options) ->
    @categories = new EventSalsa.Collections.CategoriesCollection()
    @categories.fetch
      success: => @index()

  routes:
    "categories/index"                : "index"
    "categories/:id/events/upcoming"  : "indexUpcomingEvents"
    "categories/:id/events/recent"    : "indexRecentEvents"

  index: ->
    @view = new EventSalsa.Views.Categories.IndexView(categories: @categories)
    $("#categories").html(@view.render().el)

  indexUpcomingEvents: (id) ->
    @upcomingEvents ||= {}
    @upcomingEvents[id] ||= new EventSalsa.Collections.EventsCollection
      rootPath: "/categories/#{id}/events"
      query: '/upcoming'
    @upcomingEvents[id].fetch
      success: =>
        @view = new EventSalsa.Views.Events.IndexView(events: @upcomingEvents[id])
        $("#events").html(@view.render().el)

  indexRecentEvents: (id) ->
    @recentEvents ||= {}
    @recentEvents[id] ||= new EventSalsa.Collections.EventsCollection
      rootPath: "/categories/#{id}/events"
      query: '/recent'
    @recentEvents[id].fetch
      success: =>
        @view = new EventSalsa.Views.Events.IndexView(events: @recentEvents[id])
        $("#events").html(@view.render().el)
