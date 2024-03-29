EventSalsa.module "Layout", (LayoutApp, EventSalsa, Backbone, Marionette, $, _) ->
  # Event Bindings
  # --------------
  EventSalsa.vent.bind 'events:category:clear', ->
    EventSalsa.layout.$('#attending-events').parent().removeClass 'active'

  # Views
  # -----
  class Layout extends Marionette.Layout
    template: JST["templates/layout"]
    regions:
      categories: "#category-list"
      content: "#content"
    events:
      'click .coming-soon'       : 'trackClick'
      'click #about'             : 'showAboutPage'
      'click #contact'           : 'showContactPage'
      'click .brand'             : 'showEventList'
      'click .all-events'        : 'showEventList'
      'click .attending-events'  : 'showEventListByAttending'
      'click .managing-events'   : 'showEventListByManaging'
      'submit #search-bar'       : 'showEventListByQuery'
      'click #navbar a'          : 'showNavItem'
    navItemEvents:
      #'calendar': 'events:calendar:show'
      'events': 'events:show'
    onRender: ->
      # Set up tooltips for "Coming Soon" features
      @$('#navbar a.coming-soon').tooltip
        trigger: 'click'
        placement: 'bottom'
      @$('#meta-nav-list a.coming-soon').tooltip
        trigger: 'click'
        placement: 'right'

      @$('.coming-soon').on 'click', ->
        $(@).tooltip 'show'
        setTimeout =>
          $(@).tooltip 'hide'
        , 2000
    trackClick: (e) ->
      e.preventDefault()
      EventSalsa.Routing.trackRoute $(e.target).attr('href')
    showAboutPage: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'pages:about:show'
    showContactPage: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'pages:contact:show'
    showEventList: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'events:show', e
    showEventListByAttending: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'events:show:attending', EventSalsa.currentUser.id
    showEventListByManaging: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'events:show:managing', EventSalsa.currentUser.id
    showEventListByQuery: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger 'events:show:search', $(e.target).find('input').val()
    showNavItem: (e) ->
      if $(e.target).is('#login-button')
        e.preventDefault()
      EventSalsa.vent.trigger 'events:category:clear'
      EventSalsa.vent.trigger @navItemEvents[$(e.target).data('target')]

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventSalsa.layout = new Layout()
    EventSalsa.layout.on 'show', ->
      EventSalsa.vent.trigger 'layout:rendered'

    EventSalsa.application.show EventSalsa.layout
