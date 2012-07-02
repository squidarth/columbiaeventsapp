#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.EventSalsa =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

#class EventSalsa.Router extends Backbone.Router
  #routes:
    #"events/*subroute" : "invokeEventsRouter"
  #invokeEventsRouter: ->
    #if not EventSalsa.Routers.Events
      #EventSalsa.Routers.Events = new EventSalsa.Routers.EventsRouter "events/"

$ ->
  EventSalsa.Routers.Events = new EventSalsa.Routers.EventsRouter
  EventSalsa.Routers.Categories = new EventSalsa.Routers.CategoriesRouter
  #EventSalsa.App = new EventSalsa.Router()
  Backbone.history.start()
