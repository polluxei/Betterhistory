class BH.Views.VisitsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'visits_view'

  template: BH.Templates['visits']

  events:
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @collection.on 'reset', @renderVisits, @
    @model.on 'change:date', @onDateChange, @

  pageTitle: ->
    'Visits'

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.append html

    timelineView = new BH.Views.TimelineView model: @model
    @$('.controls').html timelineView.render().el

    @

  onDateChange: (ev) ->
    @$('.visits_content').addClass('disappear')
    setTimeout (=> @$('.visits_content').html ''), 250

  renderVisits: ->
    visitsResultsView = new BH.Views.VisitsResultsView
      collection: @collection

    @$('.visits_content').html visitsResultsView.render().el
    @$('.visits_content').removeClass('disappear')
    visitsResultsView.inflateDates()

  getI18nValues: ->
    @t ['search_input_placeholder_text']
