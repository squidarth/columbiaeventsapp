EventSalsa.module "Layout", (Layout, EventSalsa, Backbone, Marionette, $, _) ->
  Layout = Backbone.Marionette.Layout.extend
    template: JST["templates/layout"]

    regions:
      categories: "#category-list"
      content: "#content"

  EventSalsa.addInitializer ->
    EventSalsa.layout = new Layout()

    EventSalsa.layout.on 'show', ->
      EventSalsa.vent.trigger 'layout:rendered'

    EventSalsa.content.show(EventSalsa.layout)
