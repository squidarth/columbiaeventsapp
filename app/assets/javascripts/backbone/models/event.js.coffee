class EventSalsa.Models.Event extends Backbone.Model
  paramRoot: 'event'
  urlRoot: '/events'

  defaults:
    name: null
    description: null
    date: null

class EventSalsa.Collections.EventsCollection extends Backbone.Collection
  model: EventSalsa.Models.Event
  url: '/events/recent'
