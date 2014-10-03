class BH.Views.SearchView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'search_view with_controls'
  template: BH.Templates['search']

  events:
    'click .fresh_search': 'clickedFreshSearch'
    'click .search_deeper': 'clickedSearchDeeper'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @collection.on 'reset', @onHistoryChanged, @
    @model.on 'change:query', @onQueryChanged, @
    @model.on 'change:cacheDatetime', @onCacheChanged, @

  render: ->
    presenter = new BH.Presenters.SearchPresenter(@model.toJSON())
    properties = _.extend(@getI18nValues(), presenter.searchInfo())
    html = Mustache.to_html @template, properties
    @$el.append html

    @searchControlsView = new BH.Views.SearchControlsView
      model: @model
      collection: @collection
      el: @$('.search_controls')
    @searchControlsView.render()

    @

  pageTitle: ->
    @t 'searching_title'

  onHistoryChanged: ->
    @$el.removeClass 'loading'
    @renderVisits()
    @assignTabIndices('.visit a.item')

  onCacheChanged: ->
    if @model.get('cacheDatetime')
      datetime = moment(@model.get('cacheDatetime'))
      date = datetime.format(@t('extended_formal_date'))
      time = datetime.format(@t('local_time'))
      @$('.cached .datetime').text "#{time} #{date}"
      @$('.cached').show()
    else
      @$('.cached').hide()

  onQueryChanged: ->
    @searchControlsView.render()
    if @model.get('query')?
      @$('.cached').hide()
      @$el.addClass('loading')

      presenter = new BH.Presenters.SearchPresenter(@model.toJSON())
      properties = presenter.searchInfo()
      @$('.title').text properties.title
      @$('.visits_content').html('')

  clickedFreshSearch: (ev) ->
    ev.preventDefault()
    new Historian.Search().expireCache()
    window.location.reload()

  clickedSearchDeeper: (ev) ->
    ev.preventDefault()
    @$('.number_of_visits').html ''
    @$('.search_deeper').addClass('searching')
    @$('.pagination').html ''
    @$el.addClass('loading')
    @searchDeeper()

  searchDeeper: ->
    # This is a shitty solution
    @deepSearched = true

    options =
      startAtResult: 5001
      maxResults: 0

    new Historian.Search(@model.get('query')).fetch (options), (history) =>
      @$('.search_deeper').hide()
      @collection.add history
      @$el.removeClass('loading')

  renderVisits: ->
    @$el.removeClass('loading')
    @$('.search').focus()

    @$('.visits_content').addClass('disappear')
    setTimeout =>
      @$('.visits_content').html ''
      @searchResultsView.undelegateEvents() if @searchResultsView

      @searchResultsView = new BH.Views.SearchResultsView
        query: @model.get('query')
        collection: @collection
        el: @$('.visits_content')
        page: @searchControlsView.page
        deepSearched: @deepSearched
      @$('.visits_content').removeClass('disappear')

      @searchResultsView.render()

      @delay = 50
    , @delay || 0

  getI18nValues: ->
    @t [
      'search_input_placeholder_text',
      'no_visits_found'
    ]
