EventSalsa.module 'EventsApp.Calendar', (Calendar, EventSalsa, Backbone, Marionette, $, _) ->
  # Public API
  # ----------
  Calendar.showCalendar = (attendingEvents) ->
    prepareCalendarLayout()
    fetchAttendingEvents()

  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'events:calendar:show', ->
    window.scrollTo 0
    Calendar.showCalendar()

  # Views
  # -----
  class Calendar.CalendarView extends Marionette.Layout
    template: JST["templates/events/calendar/calendar"]
    regions:
      events: '#calendar-events'

  class Calendar.EventView extends Marionette.ItemView
    template: JST["templates/events/calendar/event"]

  class Calendar.EventListView extends Marionette.CollectionView
    itemView: Calendar.EventView

  # Private API
  # -----------
  fetchAttendingEvents = ->
    $.getJSON "/users/#{EventSalsa.currentUser.id}/attendings.json", (data) ->
      Calendar.attendingEvents.reset data.map (attending) ->
        attending.event
      prepareCalendarEvents Calendar.attendingEvents

  prepareCalendarLayout = ->
    if !Calendar.calendarView or EventSalsa.layout.content.currentView != Calendar.calendarView
      Calendar.calendarView = new Calendar.CalendarView()
      EventSalsa.layout.content.show Calendar.calendarView

  prepareCalendarEvents = (attendingEvents) ->
    attendingEventsView = new Calendar.EventListView
      collection: attendingEvents
    Calendar.calendarView.events.show attendingEventsView

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    Calendar.attendingEvents = new EventSalsa.EventsApp.Attendings.AttendingCollection()
