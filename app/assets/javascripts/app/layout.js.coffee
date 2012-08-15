EventSalsa.module "Layout", (LayoutApp, EventSalsa, Backbone, Marionette, $, _) ->
  # Views
  # -----
  class Layout extends Marionette.Layout
    template: JST["templates/layout"]
    regions:
      categories: "#category-list"
      content: "#content"
    events:
      'click #navbar a'  : 'showModule'
      'submit form'      : 'showEventListByQuery'
      'click .brand'     : 'showEventList'
      'click #about'     : 'showAboutPage'
      'click #contact'   : 'showContactPage'
    modules:
      'calendar': 'events:calendar:show'
      'events': 'events:show'
    showModule: (e) ->
      $('#navbar li').removeClass 'active'
      $(e.target).parent().addClass 'active'
      EventSalsa.vent.trigger @modules[$(e.target).data('target')]
    showEventListByQuery: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:show:search', $(e.target).find('input').val()
    showEventList: ->
      EventSalsa.vent.trigger 'events:show'
    showAboutPage: ->
      EventSalsa.vent.trigger 'pages:about:show'
    showContactPage: ->
      EventSalsa.vent.trigger 'pages:contact:show'

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventSalsa.layout = new Layout()

    EventSalsa.layout.on 'show', ->
      EventSalsa.vent.trigger 'layout:rendered'

    EventSalsa.application.show EventSalsa.layout
