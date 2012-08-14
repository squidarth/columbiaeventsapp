Helpers.Scroll ||= {}

Helpers.Scroll.nearEndOfPage = (margin = 50) ->
  window.scrollY + $(window).height() + margin > document.height

$ ->
  $(window).on 'scroll', ->
    if Helpers.Scroll.nearEndOfPage()
      EventSalsa.vent.trigger 'scroll:bottom'
