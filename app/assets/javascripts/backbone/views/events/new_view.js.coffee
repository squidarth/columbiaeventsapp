EventSalsa.Views.Events ||= {}

class EventSalsa.Views.Events.NewView extends Backbone.View
  template: JST["backbone/templates/events/new"]

  events:
    "submit #new-event": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (event) =>
        @model = event
        window.location.hash = "/#{@model.id}"

      error: (event, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
