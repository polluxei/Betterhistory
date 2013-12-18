class BH.Views.WeeksView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['weeks']

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
    properties = _.extend @getI18nValues()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onHistoryLoaded: ->
    @renderHistory()

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
      @history.destroy()
      @promptView.close()
      @history.fetch()
    else
      @promptView.close()

  getI18nValues: ->
    @t [
      'all_weeks_title',
      'delete_all_weeks_button',
      'no_visits_found',
      'search_input_placeholder_text'
    ]
