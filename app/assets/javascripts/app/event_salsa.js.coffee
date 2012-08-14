#= require_self
#= require_tree ../app
#= require_tree ../routers
#= require_tree ../helpers
#= require_tree ../templates

window.EventSalsa = new Backbone.Marionette.Application()

window.Helpers = {}

EventSalsa.addRegions
  application: '#application'

EventSalsa.vent.on 'layout:rendered', ->
  EventSalsa.bind 'initialize:after', ->
    Backbone.history.start()

EventSalsa.bind 'initialize:before', ->
  Backbone.Marionette.Renderer.render = (template, data) -> template(data) if template
  #Backbone.Marionette.Region.prototype.open = (view) ->
    #@$el.html view.el.$el.html()

$ ->
  # Facebook redirect_uri #_=_ bug workaround
  if window.location.hash[1] == '_'
    window.location.hash = ''

  EventSalsa.start()
