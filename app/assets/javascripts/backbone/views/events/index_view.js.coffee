EventSalsa.Views.Events ||= {}

class EventSalsa.Views.Events.IndexView extends Backbone.View
  template: JST["backbone/templates/events/index"]

  initialize: () ->
    @options.events.bind('reset', @addAll)

  addAll: () =>
    @options.events.each(@addOne)

  addOne: (event) =>
    view = new EventSalsa.Views.Events.EventView({model : event})
    @$("ul").append(view.render().el)

  render: =>
    $(@el).html @template
      events: @options.events.toJSON()
      rootPath: @options.events.rootPath
    @addAll()
    return this
