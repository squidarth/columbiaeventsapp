EventSalsa.module "Layout", (Layout, EventSalsa, Backbone, Marionette, $, _) ->
  # Views
  # -----
  class Layout extends Marionette.Layout
    template: JST["templates/layout"]
    regions:
      categories: "#category-list"
      content: "#content"
    events:
      'submit form'      : 'showEventListByQuery'
      'click .brand'     : 'showEventList'
      'click #navbar a'  : 'showModule'
      'click #about'     : 'showAboutPage'
      'click #contact'   : 'showContactPage'
    showEventListByQuery: (e) ->
      e.preventDefault()
      EventSalsa.vent.trigger 'events:show:search', $(e.target).val()
    showEventList: ->
      EventSalsa.vent.trigger 'events:show'
    showModule: ->
      return
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
