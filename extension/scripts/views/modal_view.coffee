class BH.Views.ModalView extends Backbone.View
  pulseClass: 'pulse'

  generalEvents:
    'click .close-button': 'close'
    'click .overlay': 'overlayClicked'

  attachGeneralEvents: ->
    _.extend(@events, @generalEvents)

  renderTemplate: (json) ->
    overlay = $(BH.Templates['modal'])
    $('.page', overlay).append(Mustache.to_html(@template, json))
    overlay

  open: (callback = ->) ->
    $('body').append(@render().el)
    @_globalBinds()
    $(window).trigger('resize')
    setTimeout( ->
      @$('.overlay').removeClass('transparent')
      callback()
    , 0)

  overlayClicked: ->
    @$('.page').addClass('pulse')
    @$('.page').on 'webkitAnimationEnd', =>
      @$('.page').removeClass('pulse')

  close: ->
    @trigger('close')
    @$('.overlay').addClass('transparent')
    setTimeout( =>
      @remove()
    , 1000)
    @_globalUnbinds()

  _globalBinds: ->
    $(window).resize(@_updateHeight)
    $(window).keydown($.proxy(@_closeOnEscape, @))

  _globalUnbinds: ->
    $(window).unbind('resize')
    $(document).unbind('keydown')

  _updateHeight: ->
    @$('.page').css
      maxHeight: Math.min(0.9 * window.innerHeight, 640)

  _closeOnEscape: (e) ->
    if e.keyCode == 27
      @close()
