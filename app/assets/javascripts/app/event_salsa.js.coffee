#= require_self
#= require layout
#= require_tree ../controllers
#= require_tree ../routers
#= require_tree ../templates
#= require_tree ../views

window.EventSalsa = new Backbone.Marionette.Application()

EventSalsa.addRegions
  application: '#application'

EventSalsa.vent.on 'layout:rendered', ->
  Backbone.history.start()

$ ->
  EventSalsa.start()
