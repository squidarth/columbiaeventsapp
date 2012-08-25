EventSalsa.module 'EventsApp.Attendings', (Attendings, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # Models
  # ------
  class Attendings.Attending extends Backbone.Model
    paramRoot: 'attending'
    urlRoot: '/attendings'

  class Attendings.AttendingCollection extends Backbone.Collection
    model: Attendings.Attending
    url: '/attendings'

  class Attendings.AttendingMetaData extends Backbone.Model

  # Views
  # ------
  class Attendings.AttendingDetailView extends Marionette.Layout
    template: JST["templates/attendings/detail"]
    initialize: (options) ->
      @attendingList = new Attendings.AttendingCollection options.collection.models.filter (attending) ->
        attending.get('status') is 'attending'
      @unsureList = new Attendings.AttendingCollection options.collection.models.filter (attending) ->
        attending.get('status') is 'unsure'
      @model = new Attendings.AttendingMetaData
        attending_count: @attendingList.length
        unsure_count: @unsureList.length

  class Attendings.AttendingControlView extends Marionette.ItemView
    template: JST["templates/attendings/control"]
    events:
      'click .attend-status': 'attendStatusChanged'
      'click .attend-option a': 'attendStatusChanged'
    initialize: (options) ->
      @parent = options.parent
    attendStatusChanged: (e) ->
      previousStatus = @model.get('status')
      target = $(e.target)
      if target.hasClass 'attend-status'
        targetAttendStatus = if @model.get('status') is 'attending' then 'declined' else 'attending'
      else
        targetAttendStatus = target.data('value')

      @$('.attend-status').removeClass Helpers.Bootstrap.buttonClasses
      @$('.attend-status').attr 'disabled', yes

      # [TODO] Refactor model manipulation into Model
      @model.set 'status', targetAttendStatus
      @model.save @model.attributes,
        success: (event) =>
          @parent.reloadAttendingData()
        error: (event, response) =>
          @model.set
            status: previousStatus
            errors: $.parseJSON(response.responseText)
          @parent.reloadAttendingData()
