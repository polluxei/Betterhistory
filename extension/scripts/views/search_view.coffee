class BH.Views.SearchView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Url

  className: 'search_view with_controls'
  template: BH.Templates['search']

  events:
    'click .delete_all': 'clickedDeleteAll'
    'click .corner .delete': 'clickedCancelSearch'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @history = @options.history
    @page = new Backbone.Model(page: 1)

    @history.on('change:history', @onSearchHistoryChanged, @)
    @model.on('change:query', @onQueryChanged, @)
    @page.on('change:page', @renderSearchResults, @)

  render: ->
    properties = _.extend(@getI18nValues(), @model.toTemplate())
    html = Mustache.to_html @template, properties
    @$el.append html
    if !@model.validQuery()
      @$el.addClass('loaded')
      @$('.title').text @t('search_title')
      @$('.number_of_results').text ''
      setTimeout =>
        @assignTabIndices('.visit a:first-child')
      , 0
    @updateDeleteButton()
    @

  pageTitle: ->
    @t 'searching_title'

  onSearchHistoryChanged: ->
    @renderVisits()
    @assignTabIndices('.visit a:first-child')
    @updateDeleteButton()

  onQueryChanged: ->
    @updateQueryReferences()
    $('.pagination').html('')
    if @model.validQuery()
      @history.set {query: @model.get('query')}, silent: true
      @$('.corner').addClass('cancelable')

  onPageClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    $('.pagination a').removeClass('selected')
    $el.addClass('selected')

    @renderSearchResults()

  updateQueryReferences: ->
    properties = @model.toTemplate()
    @$el.removeClass('loaded')
    @$('.title').text properties.title
    @$('.content').html('')

    # if we are on the first page, don't show it in the URL
    page = if @page.get('page') != 1 then "/p#{@page.get('page')}" else ""

    router.navigate @urlFor('search', properties.query) + page

  renderVisits: ->
    @$el.addClass('loaded')
    @$('.search').focus()

    searchPaginationView = new BH.Views.SearchPaginationView
      results: @history.get('history').length
      query: @model.get('query')
      el: $('.pagination')
      model: @page
    searchPaginationView.render()

    @renderSearchResults()

  renderSearchResults: ->
    @searchResultsView.undelegateEvents() if @searchResultsView
    @searchResultsView = new BH.Views.SearchResultsView
      model: @history
      el: @$el.children('.content')
      page: @page.get('page') - 1
    @searchResultsView.render()

  updateDeleteButton: ->
    deleteButton = @$('.delete_all')
    if @history.isEmpty() || !@model.validQuery()
      deleteButton.attr('disabled', 'disabled')
    else
      deleteButton.removeAttr('disabled')

  clickedCancelSearch: (ev) ->
    ev.preventDefault()
    router.navigate('search', trigger: true)

  clickedDeleteAll: (ev) ->
    ev.preventDefault()
    if $(ev.target).parent().attr('disabled') != 'disabled'
      @promptView = BH.Views.CreatePrompt(@t('confirm_delete_all_search_results'))
      @promptView.open()
      @promptView.model.on('change', @deleteAction, @)

  deleteAction: (prompt) ->
    if prompt.get('action')
      track.searchResultsDeletion()
      @history.get('history').destroyAll()
      @history.fetch
        success: (model) =>
          model.trigger('change:history') # make sure
          @promptView.close()
    else
      @promptView.close()

  getI18nValues: ->
    @t [
      'search_time_frame',
      'search_input_placeholder_text',
      'delete_all_visits_for_search_button',
      'no_visits_found'
    ]
