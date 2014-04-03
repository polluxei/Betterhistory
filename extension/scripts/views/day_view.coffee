class BH.Views.DayView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['day']

  className: 'day_view with_controls'

  events:
    'click .delete_day': 'onDeleteAllClicked'
    'click .back_to_week': 'onBackToWeekClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'
    'click .remove_filter': 'onRemoveSearchFilterClick'

  initialize: ->
    @collection.bind('reset', @onHistoryLoaded, @)

  render: ->
    presenter = new BH.Presenters.DayPresenter(@model.toJSON())
    properties = _.extend @getI18nValues(), presenter.dayInfo()
    html = Mustache.to_html(@template, properties)
    @$el.html html
    @

  onHistoryLoaded: ->
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
      collection: @collection
    @$('.content').html @dayResultsView.render().el
    @dayResultsView.insertTags()
    @dayResultsView.attachDragging()

    @$('.spinner').hide()
    @$('.back_to_week').css opacity: 1

  updateDeleteButton: ->
    deleteButton = @$('button')
    if @collection.length == 0
      deleteButton.attr('disabled', 'disabled')
    else
      deleteButton.removeAttr('disabled')

  updateUrl: ->
    router.navigate(BH.Lib.Url.week(@options.weekModel.id))

  promptToDeleteAllVisits: ->
    presenter = new BH.Presenters.DayPresenter(@model.toJSON())

    promptMessage = @t('confirm_delete_all_visits', [presenter.dayInfo().formalDate])
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      analyticsTracker.dayVisitsDeletion()
      new BH.Lib.DayHistory(@model.get('date')).destroy ->
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
