EventSalsa.module 'CategoriesController', (CategoriesController, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  CategoriesController.showCategoryList = ->
    EventSalsa.CategoriesController.Categories.show CategoriesController.categories

  # Models
  # ------
  class EventSalsa.CategoriesController.Category extends Backbone.Model
    paramRoot: 'category'
    urlRoot: '/categories'

    defaults:
      name: null

  class EventSalsa.CategoriesController.CategoryCollection extends Backbone.Collection
    model: EventSalsa.Models.Category
    url: '/categories'

  # Private API
  # -----------

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    CategoriesController.categories = new CategoriesController.CategoryCollection()
    CategoriesController.categories.fetch()
