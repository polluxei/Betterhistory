class BH.Views.SearchView extends BH.Views.MainView
  @include BH.Modules.I18n

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
    @history.on('change:history', @onSearchHistoryChanged, @)
    @model.on('change:query', @onQueryChanged, @)

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
    if @model.validQuery()
      @history.set {query: @model.get('query')}, silent: true
      @$('.corner').addClass('cancelable')

  updateQueryReferences: ->
    properties = @model.toTemplate()
    @$el.removeClass('loaded')
    @$('.title').text properties.title
    @$('.search').val properties.query
    @$('.content').html('')

  renderVisits: ->
    @$el.addClass('loaded')

    @$('.search').focus()
    contentElement = @$el.children('.content')

    if @history.get('history').length == 100
      key = 'max_number_of_search_results'
    else
      key = 'number_of_search_results'

    @$('.number_of_results').text(@t(key, [@history.get('history').length]))


    new BH.Views.SearchResultsView(
      model: @history
      el: contentElement
    ).render()

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
