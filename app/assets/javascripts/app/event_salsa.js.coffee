#= require_self
#= require ./layout
#= require_tree ./events
#= require routers/events_router
#= require_tree ../templates

window.EventSalsa = new Backbone.Marionette.Application()

EventSalsa.addRegions
  application: '#application'

EventSalsa.vent.on 'layout:rendered', ->
  EventSalsa.bind 'initialize:after', ->
    Backbone.history.start()

EventSalsa.bind 'initialize:before', ->
  Backbone.Marionette.Renderer.render = (template, data) -> template(data) if template

$ ->
  EventSalsa.start()
