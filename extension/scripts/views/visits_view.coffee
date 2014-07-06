class BH.Views.VisitsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'visits_view'

  template: BH.Templates['visits']

  events:
    'click a.date': 'onDateClicked'
    'click a.next': 'onNextClicked'
    'click a.previous': 'onPreviousClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @collection.on 'reset', @renderVisits, @
    @model.on 'change:date', @onDateChange, @

  pageTitle: ->
    'Visits'

  render: ->
    dates = for i in [0..6]
      date = moment().startOf('day').subtract 'days', i
      label: date.format('dddd')
      date: "#{date.format('MMM D')}#{date.format('Do')}"
      selected: true if date.isSame(@model.get('date'))
      id: date.format('M-D-YY')

    properties = _.extend @getI18nValues(), dates: dates
    html = Mustache.to_html @template, properties
    @$el.append html
    @

  onDateClicked: (ev) ->
    @$('a').removeClass('selected')
    @$('.content').html ''
    $(ev.currentTarget).addClass('selected')

  onNextClicked: (ev) ->
    ev.preventDefault()
    console.log 'next'

  onPreviousClicked: (ev) ->
    ev.preventDefault()
    console.log 'prev'

  renderVisits: ->
    visitsResultsViews = new BH.Views.VisitsResultsView
      collection: @collection
    @$('.content').html visitsResultsViews.render().el

  getI18nValues: ->
    @t ['search_input_placeholder_text']
