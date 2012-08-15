EventSalsa.module "Layout", (LayoutApp, EventSalsa, Backbone, Marionette, $, _) ->
  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'events:category:clear', ->
    EventSalsa.layout.$('#my-events').parent().removeClass 'active'

  # Views
  # -----
  class Layout extends Marionette.Layout
    template: JST["templates/layout"]
    regions:
      categories: "#category-list"
      content: "#content"
    events:
      'click #navbar a'   : 'showNavItem'
      'click #my-events'  : 'showEventListByAttending'
      'submit form'       : 'showEventListByQuery'
      'click .brand'      : 'showEventList'
      'click #about'      : 'showAboutPage'
      'click #contact'    : 'showContactPage'
    navItemEvents:
      'calendar': 'events:calendar:show'
      'events': 'events:show'
    showNavItem: (e) ->
      $('#navbar li').removeClass 'active'
      $(e.target).parent().addClass 'active'
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger @navItemEvents[$(e.target).data('target')]
    showEventListByQuery: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'events:show:search', $(e.target).find('input').val()
    showEventList: ->
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'events:show'
    showAboutPage: ->
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'pages:about:show'
    showContactPage: ->
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'pages:contact:show'
    showEventListByAttending: ->
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'events:show:attending'

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventSalsa.layout = new Layout()

    EventSalsa.layout.on 'show', ->
      EventSalsa.vent.trigger 'layout:rendered'

    EventSalsa.application.show EventSalsa.layout
