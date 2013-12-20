class BH.Views.DayView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['day']

  className: 'day_view with_controls'

  events:
    'click .delete_day': 'onDeleteAllClicked'
    'click .back_to_week': 'onBackToWeekClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @model.on 'change:history', @onDayHistoryLoaded, @

  render: ->
    presenter = new BH.Presenters.DayPresenter(@model)
    properties = _.extend @getI18nValues(), presenter.day()
    html = Mustache.to_html(@template, properties)
    @$el.html html
    @

  onDayHistoryLoaded: ->
    @renderHistory()
    @assignTabIndices('.interval > .visits > .visit > a:first-child')
    @updateDeleteButton()

  onDeleteAllClicked: (ev) ->
    @promptToDeleteAllVisits()

  onBackToWeekClicked: ->
    @$('.content').html('')

  pageTitle: ->
    presenter = new BH.Presenters.DayPresenter(@model)
    presenter.day().formalDate

  renderHistory: ->
    @dayResultsView = new BH.Views.DayResultsView
      model: @model
    @$('.content').html @dayResultsView.render().el
    @dayResultsView.insertTags()
    @dayResultsView.attachDragging()

  updateDeleteButton: ->
    deleteButton = @$('button')
    if @model.get('history').length == 0
      deleteButton.attr('disabled', 'disabled')
    else
      deleteButton.removeAttr('disabled')

  updateUrl: ->
    router.navigate(BH.Lib.Url.week(@options.weekModel.id))

  promptToDeleteAllVisits: ->
    presenter = new BH.Presenters.DayPresenter(@model)

    promptMessage = @t('confirm_delete_all_visits', [presenter.day().formalDate])
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      analyticsTracker.dayVisitsDeletion()
      @history.destroy()
      @history.fetch
        success: =>
          @promptView.close()
    else
      @promptView.close()

  getI18nValues: ->
    properties = @t [
      'collapse_button',
      'expand_button',
      'delete_all_visits_for_filter_button',
      'no_visits_found',
      'search_input_placeholder_text',
    ]
    properties['i18n_back_to_week_link'] = @t('back_to_week_link', [
      @t('back_arrow')
    ])
    properties
