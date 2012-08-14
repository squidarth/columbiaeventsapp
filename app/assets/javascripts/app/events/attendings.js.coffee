EventSalsa.module 'EventsApp.Attendings', (Attendings, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # Models
  # ------
  class Attendings.Attending extends Backbone.Model
    paramRoot: 'attending'
    urlRoot: '/attendings'

  # Views
  # ------
  class Attendings.AttendingStatusView extends Marionette.ItemView
    template: JST["templates/events/attending"]
    events:
      'click .attend-status': 'attendStatusChanged'
      'click .attend-option a': 'attendStatusChanged'
    attendStatusChanged: (e) ->
      previousStatus = @model.get('status')
      target = $(e.target)
      if target.hasClass 'attend-status'
        targetAttendStatus = if @model.get('status') == 'YES' then 'NO' else 'YES'
      else
        targetAttendStatus = target.data('value')

      @$('.attend-status').removeClass Helpers.Bootstrap.buttonClasses
      @$('.attend-status').attr 'disabled', yes

      # [TODO] Refactor model manipulation into Model
      @model.set 'status', targetAttendStatus
      @model.save @model.attributes,
        success: (event) =>
          @render()
        error: (event, response) =>
          @model.set
            status: previousStatus
            errors: $.parseJSON(response.responseText)
          @render()
