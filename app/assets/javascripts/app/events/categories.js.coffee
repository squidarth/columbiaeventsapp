EventSalsa.module 'EventsApp.Categories', (Categories, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  Categories.showCategoryList = ->
    Categories.categories ||= new Categories.CategoryCollection()
    Categories.categories.bind 'reset', prepareCategoryListView
    Categories.categories.fetch()

  Categories.categoryControlListViewFromCategories = ->
    new EventSalsa.EventsApp.Categories.CategoryControlListView
      collection: Categories.categories

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'layout:rendered', ->
    Categories.showCategoryList()

  EventSalsa.vent.bind 'events:category:clear', ->
    EventSalsa.layout.categories.currentView.highlightCategoryWithId null

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
    template: JST["templates/categories/link"]
    tagName: 'li'
    events:
      'click a': 'showEventsByCategory'
    showEventsByCategory: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger('events:category:clear', @model)
      EventSalsa.vent.trigger('events:show:category', @model)

  class Categories.CategoryListView extends Marionette.CollectionView
    itemView: Categories.CategoryView
    tagName: 'ul'
    className: 'nav nav-list'
    highlightCategoryWithId: (id) ->
      @$('li').removeClass 'active'
      @$("a[data-id=#{id}]").parent().addClass 'active'

  class Categories.CategoryControlView extends Marionette.ItemView
    template: JST["templates/categories/control"]
    tagName: 'label'
    className: 'span2 pull-left'

  class Categories.CategoryControlListView extends Marionette.CollectionView
    itemView: Categories.CategoryControlView
    className: 'row controls'

  # Private API
  # -----------
  prepareCategoryListView = ->
    categoryListView = new Categories.CategoryListView
      collection: Categories.categories
    EventSalsa.layout.categories.show categoryListView

    route = window.location.hash.split('/')
    if route[0] is '#categories'
      categoryListView.highlightCategoryWithId route[1]

