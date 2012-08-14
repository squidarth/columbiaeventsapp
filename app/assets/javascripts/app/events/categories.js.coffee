EventSalsa.module 'EventsApp.Categories', (Categories, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  Categories.showCategoryList = ->
    Categories.categories ||= new Categories.CategoryCollection()
    Categories.categories.bind 'reset', prepareCategoryListView
    Categories.categories.fetch()

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'layout:rendered', ->
    Categories.showCategoryList()

  # Models
  # ------
  class Categories.Category extends Backbone.Model
    paramRoot: 'category'
    urlRoot: '/categories'

  class Categories.CategoryCollection extends Backbone.Collection
    model: Categories.Category
    url: '/categories'

  # Views
  # -----
  class Categories.CategoryView extends Marionette.ItemView
    template: JST["templates/events/category"]
    tagName: 'li'
    events:
      'click a': 'showEventsByCategory'
    showEventsByCategory: ->
      EventSalsa.vent.trigger('events:show:category', @model)

  class Categories.CategoryListView extends Marionette.CollectionView
    itemView: Categories.CategoryView
    tagName: 'ul'
    className: 'nav nav-pills nav-stacked'

  # Private API
  # -----------
  prepareCategoryListView = ->
    categoryListView = new Categories.CategoryListView
      collection: Categories.categories
    EventSalsa.layout.categories.show categoryListView
