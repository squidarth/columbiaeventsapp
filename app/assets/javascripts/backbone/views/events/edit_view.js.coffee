EventSalsa.Views.Events ||= {}

class EventSalsa.Views.Events.EditView extends Backbone.View
  template : JST["backbone/templates/events/edit"]

  events :
    "submit #edit-event" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (event) =>
        @model = event
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
