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

  onRemoveSearchFilterClick: (ev) ->
    ev.preventDefault()
    @$('.corner .tags').hide()
    @$('.corner input').data('filter', false)

  onSearchTyped: (ev) ->
    term = @trimedSearchTerm()
    $el = $(ev.currentTarget)
    if $el.data('filter') == 'true'
      params = BH.Lib.QueryParams.write JSON.parse($el.data('filter-by'))
    if ev.keyCode == 13 && term != ''
      router.navigate("search/#{term}#{params || ''}", true)

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
