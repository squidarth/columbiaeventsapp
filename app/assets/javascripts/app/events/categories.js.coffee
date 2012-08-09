EventSalsa.module 'EventsApp.Categories', (Categories, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  Categories.showCategoryList = ->
    Categories.categories ||= new Categories.CategoryCollection()
    Categories.categories.bind 'reset', showCategories
    Categories.categories.fetch()

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
    template: JST["templates/categories/category"]
    tagName: 'li'

  class Categories.CategoryListView extends Marionette.CollectionView
    itemView: Categories.CategoryView
    tagName: 'ul'
    className: 'nav nav-pills nav-stacked'

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'layout:rendered', ->
    console.log EventSalsa.layout.categories.$el
    console.log Categories.categories
    Categories.showCategoryList()

  # Private API
  # -----------
  showCategories = ->
    categoryListView = new Categories.CategoryListView
      collection: Categories.categories
    EventSalsa.layout.categories.show categoryListView

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    Categories.categories = new Categories.CategoryCollection()
    Categories.categories.fetch()
