EventSalsa.Views.Categories ||= {}

class EventSalsa.Views.Categories.IndexView extends Backbone.View
  template: JST["backbone/templates/categories/index"]

  tagName: "ul"

  className: "categories"

  initialize: () ->
    @options.categories.bind('reset', @addAll)

  addAll: () =>
    @options.categories.each(@addOne)

  addOne: (category) =>
    view = new EventSalsa.Views.Categories.CategoryView({model : category})
    $(@el).append(view.render().el)

  render: =>
    $(@el).html(@template(categories: @options.categories.toJSON() ))
    @addAll()

    return this
