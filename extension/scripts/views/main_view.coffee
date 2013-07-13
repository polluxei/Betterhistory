class BH.Views.MainView extends Backbone.View
  select: ->
    $('.mainview > *').removeClass('selected')
    $('.mainview > *').css(display: 'block')

    setTimeout =>
      @$el.addClass('selected')
      $('.mainview > *:not(.selected)').css(display: 'none')
    , 0

    if @pageTitle
      element = $('<div/>')
      cleanTitle = $(element).html(@pageTitle()).text()
      document.title = "#{cleanTitle} - Better History"

    @trigger('selected')
    @

  onSearchTyped: (ev) ->
    term = @trimedSearchTerm()
    if ev.keyCode == 13 && term != ''
      router.navigate('search/' + term, true)

  onSearchBlurred: ->
    @$('.search').val(@trimedSearchTerm())

  trimedSearchTerm: ->
    $.trim(@$('.search').val())

  assignTabIndices: (selector) ->
    $('*').removeAttr 'tabindex'
    @$('input.search').attr 'tabindex', 1
    @$(selector).each (i) ->
      $(@).attr 'tabindex', i + 2
    @$('.search').focus()
