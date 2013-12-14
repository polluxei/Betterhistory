class BH.Views.WeekView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['week']

  className: 'week_view with_controls'

  events:
    'click .delete_all': 'onDeleteAllClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @history = @options.history
    @history.bind('change', @onHistoryLoaded, @)

  render: ->
    presenter = new BH.Presenters.WeekPresenter(@model)
    properties = _.extend @getI18nValues(), presenter.week()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onHistoryLoaded: ->
    @renderHistory()

  onDeleteAllClicked: ->
    @promptToDeleteAllVisits()

  pageTitle: ->
    presenter = new BH.Presenters.WeekPresenter(@model)
    presenter.week().title

  renderHistory: ->
    presenter = new BH.Presenters.WeekHistoryPresenter(@history)
    history = presenter.history()
    for day in history.days
      container = @$("[data-day=#{day.day}]")
      container.find(".label .count").html @t('number_of_visits', [day.count])
      container.find('.bar').css width: day.percentage

    @$('.controls .count').html @t('number_of_visits', [history.total])
    @assignTabIndices('.day a')
    @$el.addClass('loaded')

  promptToDeleteAllVisits: ->
    presenter = new BH.Presenters.WeekHistoryPresenter(@history)
    promptMessage = @t('confirm_delete_all_visits', [presenter.history().title])
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      analyticsTracker.weekVisitsDeletion()
      @history.destroy()
      @promptView.close()
      @history.fetch()
    else
      @promptView.close()

  getI18nValues: ->
    @t [
      'delete_all_visits_for_filter_button',
      'no_visits_found',
      'search_input_placeholder_text'
    ]
