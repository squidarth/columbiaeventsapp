class EventSalsa.Models.Event extends Backbone.Model
  paramRoot: 'event'
  urlRoot: '/events'

  defaults:
    name: null
    description: null
    date: null

class EventSalsa.Collections.EventsCollection extends Backbone.Collection
  model: EventSalsa.Models.Event
  url: ->
    @rootPath + @query

  initialize: (options) ->
    @rootPath = (options.rootPath if options) || '/events'
    @query    = (options.query if options) || '/recent'
