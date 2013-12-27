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
    @model.on 'change:history', @onDayHistoryLoaded, @

  render: ->
    presenter = new BH.Presenters.DayPresenter(@model.toJSON())
    properties = _.extend @getI18nValues(), presenter.dayInfo()
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
    presenter = new BH.Presenters.DayPresenter(@model.toJSON())
    presenter.dayInfo().formalDate

  renderHistory: ->
    @dayResultsView = new BH.Views.DayResultsView
      collection: new Backbone.Collection(@model.get('history').toJSON())
    @$('.content').html @dayResultsView.render().el
    @dayResultsView.insertTags()
    @dayResultsView.attachDragging()

    @$('.spinner').hide()
    @$('.back_to_week').css opacity: 1

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
      new BH.Chrome.DayHistory(@model.get('date')).destroy ->
        window.location.reload()
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
