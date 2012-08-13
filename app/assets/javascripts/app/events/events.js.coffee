EventSalsa.module 'EventsApp.Events', (Events, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  Events.showEvents = (upcomingEvents, recentEvents) ->
    prepareEventLayout()
    prepareEventList upcomingEvents, recentEvents

  # Views
  # ------
  class Events.EventView extends Marionette.ItemView
    template: JST["templates/events/event"]
    tagName: 'tr'

  class Events.EventListView extends Marionette.CollectionView
    itemView: Events.EventView

  class Events.EventsView extends Marionette.Layout
    template: JST["templates/events/index"]
    regions:
      upcoming: '#upcoming-events'
      recent: '#recent-events'
      new: '#new-event'
    onRender: ->
      @newEventView = new Events.EventNewView()
      @new.show @newEventView

  class Events.EventNewView extends Marionette.ItemView
    template: JST["templates/events/new"]
    events:
      "submit #new-event": "save"
    initialize: ->
      @model = new EventSalsa.EventsApp.Event()
      @modelBinder = new Backbone.ModelBinder()
    onRender: ->
      @modelBinder.bind @model, @el
      $('.input-timepicker').timepicker()
      $('.input-datepicker').datepicker()
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
  prepareEventLayout = ->
    if !Events.eventsView or EventSalsa.layout.content.currentView != Events.eventsView
      Events.eventsView = new Events.EventsView()
      EventSalsa.layout.content.show Events.eventsView

      # [TODO] get onRender in Views to work
      Events.eventsView.$('.nav-tabs a:first').tab 'show'
      Events.eventsView.newEventView.onRender()

  prepareEventList = (upcomingEvents, recentEvents) ->
    upcomingEventsView = new Events.EventListView
      #el: Events.eventsView.upcoming.$el
      collection: upcomingEvents
    recentEventsView = new Events.EventListView
      collection: recentEvents
    Events.eventsView.upcoming.show upcomingEventsView
    Events.eventsView.recent.show recentEventsView
