EventSalsa.module 'EventsApp.Events', (Events, EventSalsa, Backbone, Marionette, $, _) ->
  console.log 'events'
  # Public API
  # ----------
  Events.showEvents = (upcomingEvents, recentEvents) ->
    prepareEventLayout()
    prepareEventList upcomingEvents, recentEvents

  Events.updateEvents = ->
    Events.eventsView.upcoming.currentView.render()
    Events.eventsView.recent.currentView.render()

  # Views
  # ------
  class Events.EventsView extends Marionette.Layout
    template: JST["templates/events/index"]
    regions:
      upcoming: '#upcoming-events'
      recent: '#recent-events'
      new: '#new-event'
    initialize: ->
      @bindTo EventSalsa.vent, 'scroll:bottom', @handleEndOfPage, @
      @newEventView = new Events.EventNewView()
    onRender: ->
      @new.show @newEventView
    handleEndOfPage: ->
      if @$('#upcoming-events').hasClass 'active'
        EventSalsa.vent.trigger 'events:more:upcoming'
      if @$('#recent-events').hasClass 'active'
        EventSalsa.vent.trigger 'events:more:recent'

  class Events.EventListView extends Marionette.CollectionView
    itemView: Events.EventView
    className: 'event-list'

  class Events.EventView extends Marionette.Layout
    template: JST["templates/events/event"]
    tagName: 'tr'
    regions:
      attendingControl: '.attending-control'
      attendingDetail: '.attending-detail'
      detail: '.event-detail'
    events:
      'click .edit': 'edit'
      'click .delete': 'destroy'
    onRender: ->
      @attendingControlView = new EventSalsa.EventsApp.Attendings.AttendingControlView
        parent: @
      if @model.attending
        @attendingControlView.model = @model.attending
      @attendingControl.show @attendingControlView

      @attendingDetailView = new EventSalsa.EventsApp.Attendings.AttendingDetailView
        collection: new EventSalsa.EventsApp.Attendings.AttendingCollection(@model.get('attendings'))
      @attendingDetail.show @attendingDetailView

      @eventDetailView = new Events.EventDetailView
        model: @model
      @detail.show @eventDetailView
    edit: ->
      if @detail.currentView is @eventDetailView
        @eventEditView ||= new Events.EventEditView
          parent: @
          model: @model
        @detail.show @eventEditView
      else
        @detail.show @eventDetailView
    destroy: ->
      @model.destroy()
    reload: ->
      @model.fetch
        success: => @render()
        error: => @render()
    reloadAttendingData: ->
      @reload()
      #@attendingControlView.render()
      #@attendingDetailView.render()

  class Events.EventDetailView extends Marionette.ItemView
    template: JST["templates/events/detail"]
    initialize: (options) ->
      @model = options.model || new EventSalsa.EventsApp.Event
    onRender: ->
      @$('.facebook-link').popover
        trigger: 'hover'
        placement: 'bottom'

  class Events.EventEditView extends Marionette.Layout
    template: JST["templates/events/edit"]
    regions:
      categories: '.categories'
    initialize: (options) ->
      @parent = options.parent
      @model = options.model
      @categoryControlListView = EventSalsa.EventsApp.Categories.categoryControlListViewFromCategories()
      # [TODO] Automatically check existing categorizations
    onRender: ->
      @categories.show @categoryControlListView
      @$('.input-timepicker').timepicker
        defaultTime: 'value'
      @$('.input-datepicker').datepicker()

      @$('form').on 'ajax:success', =>
        @parent.reload()
      @$('form').on 'ajax:error', =>
        @$('form').prepend $('<div class="alert alert-error">').text('There was a problem updating the event.')

  class Events.EventNewView extends Marionette.Layout
    template: JST["templates/events/new"]
    regions:
      categories: '.categories'
    initialize: ->
      @categoryControlListView = EventSalsa.EventsApp.Categories.categoryControlListViewFromCategories()
    onRender: ->
      @categories.show @categoryControlListView
      @$('.input-timepicker').timepicker()
      @$('.input-datepicker').datepicker()

      @$('form').on 'ajax:success', =>
        @$('form').prepend $('<div class="alert alert-success">').text('Event successfully added! Go to "My Events" to view and make changes.')
      @$('form').on 'ajax:error', =>
        @$('form').prepend $('<div class="alert alert-error">').text('There was a problem adding the event.')

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
      collection: upcomingEvents
    recentEventsView = new Events.EventListView
      collection: recentEvents
    Events.eventsView.upcoming.show upcomingEventsView
    Events.eventsView.recent.show recentEventsView
