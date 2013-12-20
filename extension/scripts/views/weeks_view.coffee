class BH.Views.WeeksView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Worker

  template: BH.Templates['weeks']

  className: 'week_view with_controls'

  events:
    'click .delete_all': 'onDeleteAllClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @collection.on 'reset', @renderHistory, @

  render: ->
    properties = _.extend @getI18nValues()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onHistoryLoaded: ->
    @renderHistory()

  renderHistory: ->
    weeksResultsView = new BH.Views.WeeksResultsView
      collection: @collection
    @$('.content', @$el).html weeksResultsView.render().el

    presenter = new BH.Presenters.AllWeeksPresenter(@collection)

    @$('.spinner').hide()
    @$('.text.count').text("#{presenter.totalVisits()} visits")
    @$('.text.count').css opacity: 1

  onDeleteAllClicked: ->
    @promptToDeleteAllVisits()

  pageTitle: ->
    @t 'all_weeks_title'

  promptToDeleteAllVisits: ->
    promptMessage = @t 'confirm_delete_all_weeks'
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      analyticsTracker.weekVisitsDeletion()
      history = new BH.Chrome.WeeksHistory()
      history.destroy()
      history.on 'destroy:complete', =>
        @promptView.close()
        @collection.reset()
    else
      @promptView.close()

  getI18nValues: ->
    @t [
      'all_weeks_title',
      'delete_all_weeks_button',
      'no_visits_found',
      'search_input_placeholder_text'
    ]
