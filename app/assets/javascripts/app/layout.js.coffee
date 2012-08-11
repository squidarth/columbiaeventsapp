EventSalsa.module "Layout", (Layout, EventSalsa, Backbone, Marionette, $, _) ->
  # Views
  # -----
  class Layout extends Marionette.Layout
    template: ->
      JST["templates/layout"]
    regions:
      categories: "#category-list"
      content: "#content"
    events:
      'click .brand'     : 'showEventList'
      'click #navbar a'  : 'showModule'
      'submit form'      : 'showEventListByQuery'
    showEventList: ->
      return
    showModule: ->
      return
    showEventListByQuery: ->
      return

  # Initializer
  # -----------
  EventSalsa.addInitializer ->
    EventSalsa.layout = new Layout()

    EventSalsa.layout.on 'show', ->
      EventSalsa.vent.trigger 'layout:rendered'

    EventSalsa.application.show(EventSalsa.layout)
