class BH.Views.SearchView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Url

  className: 'search_view with_controls'
  template: BH.Templates['search']

  events:
    'click .delete_all': 'clickedDeleteAll'
    'click .corner .delete': 'clickedCancelSearch'
    'click .fresh_search': 'clickedFreshSearch'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @collection.on('reset', @onHistoryChanged, @)
    @model.on('change:query', @onQueryChanged, @)
    @model.on 'change:cacheDatetime', @onCacheChanged, @

    @page = new Backbone.Model(page: 1)
    @page.on('change:page', @renderSearchResults, @)

  render: ->
    presenter = new BH.Presenters.SearchPresenter(@model.toJSON())
    properties = _.extend(@getI18nValues(), presenter.searchInfo())
    html = Mustache.to_html @template, properties
    @$el.append html
    if @model.get('query') == ''
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

  onHistoryChanged: ->
    @renderVisits()
    @assignTabIndices('.visit a:first-child')
    @updateDeleteButton()

  onCacheChanged: ->
    datetime = moment(@model.get('cacheDatetime'))
    date = datetime.format(@t('extended_formal_date'))
    time = datetime.format(@t('local_time'))
    @$('.cached .datetime').text "#{time} #{date}"
    @$('.cached').show()

  onQueryChanged: ->
    @updateQueryReferences()
    $('.pagination').html('')
    if @model.get('query') != ''
      new BH.Lib.SearchHistory(@model.get('query')).fetch (history) =>
        @collection.reset history
      @$('.corner').addClass('cancelable')

  onPageClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    $('.pagination a').removeClass('selected')
    $el.addClass('selected')

    @renderSearchResults()

  clickedFreshSearch: (ev) ->
    ev.preventDefault()
    new BH.Lib.SearchHistory().expireCache()
    window.location.reload()

  updateQueryReferences: ->
    presenter = new BH.Presenters.SearchPresenter(@model.toJSON())
    properties = presenter.searchInfo()
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
      results: @collection.length
      query: @model.get('query')
      el: $('.pagination')
      model: @page
    searchPaginationView.render()

    @renderSearchResults()

  renderSearchResults: ->
    @searchResultsView.undelegateEvents() if @searchResultsView
    @searchResultsView = new BH.Views.SearchResultsView
      query: @model.get('query')
      collection: @collection
      el: @$el.children('.content')
      page: @page.get('page') - 1
    @searchResultsView.render()
    @searchResultsView.insertTags()
    @searchResultsView.attachDragging()

  updateDeleteButton: ->
    deleteButton = @$('.delete_all')
    if @collection.length == 0 || @model.get('query') == ''
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
      analyticsTracker.searchResultsDeletion()
      new BH.Lib.SearchHistory(@model.get('query')).destroy =>
        @model.set history: []
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
