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

  open: ->
    $('body').append(@render().el)
    @_globalBinds()
    $(window).trigger('resize')
    setTimeout( =>
      @$('.overlay').removeClass('transparent')
      @trigger('open')
    , 0)

  overlayClicked: ->
    @$('.page').addClass('pulse')
    @$('.page').on 'webkitAnimationEnd', =>
      @$('.page').removeClass('pulse')

  close: ->
    @$('.overlay').addClass('transparent')
    setTimeout( =>
      @remove()
      @trigger('close:removed')
    , 1000)
    @_globalUnbinds()
    @trigger('close')

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
