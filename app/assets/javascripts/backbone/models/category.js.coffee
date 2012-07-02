class EventSalsa.Models.Category extends Backbone.Model
  paramRoot: 'category'
  urlRoot: '/categories'

  defaults:
    name: null

class EventSalsa.Collections.CategoriesCollection extends Backbone.Collection
  model: EventSalsa.Models.Category
  url: '/categories'
