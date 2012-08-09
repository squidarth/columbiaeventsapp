EventSalsa.module "CategoriesController.Categories", (Categories, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # Views
  # -----
  class Categories.CategoryView extends Marionette.ItemView
    template: JST["templates/categories/category"]
    tagName: 'li'

  class Categories.CategoryListView extends Marionette.CollectionView
    itemView: Categories.CategoryView
    tagName: 'ul'

  # Private API
  # -----------

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    Categories.categories = new Categories.CategoryCollection()
    Categories.categories.fetch()
