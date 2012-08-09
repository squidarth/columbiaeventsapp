EventSalsa.module 'EventsApp.Events', (Events, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  Events.show = (events) ->
    eventsView = new Events.EventListView
      collection: events
    EventSalsa.layout.content.show eventsView

  # Views
  # ------
  class Events.EventView extends Marionette.ItemView
    template: JST["templates/events/event"]
    tagName: 'li'

  class Events.EventListView extends Marionette.CollectionView
    itemView: Events.EventView
    tagName: 'ul'

  class Events.EventUpdateView extends Marionette.Layout
    template: JST["templates/events/update"]
    regions:
      create: '.new'
      update: '.edit'

  class Events.EventNewView extends Marionette.ItemView
    template: JST["templates/events/new"]
    events:
      "submit #new-event": "save"
    init: ->
      @model = new EventsApp.Event()
      @modelBinder = new Backbone.ModelBinder()
    #onRender:
      #@modelBinder.bind @model, @el
    save: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @model.unset("errors")

      @collection.create @model.attributes,
        success: (event) =>
          @model = event
          window.location.hash = "/#{@model.id}"
        error: (event, jqXHR) =>
          @model.set({errors: $.parseJSON(jqXHR.responseText)})

  class Events.EventEditView extends Marionette.ItemView
    template: JST["templates/events/edit"]
    events:
      "submit #edit-event" : "update"
    update: (e) ->
      e.preventDefault()
      e.stopPropagation()

      @model.save null,
        success : (event) =>
          @model = event
          window.location.hash = "/#{@model.id}"

  # Event Bindings
  # --------------

  # Private API
  # -----------
