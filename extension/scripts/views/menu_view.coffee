class BH.Views.MenuView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['menu']

  events:
    'click .menu > .today': 'todayClicked'
    'click .menu > .week': 'weekClicked'
    'click .menu > .calendar': 'calendarClicked'

  initialize: ->
    @chromeAPI = chrome

  render: ->
    presenter = new BH.Presenters.WeeksPresenter(@collection)
    properties = _.extend {}, @getI18nValues(), presenter.weeks()

    html = Mustache.to_html @template, properties
    @$el.html html

  todayClicked: (ev) ->
    @selectItem $(ev.currentTarget)
    analyticsTracker.todayView()

  weekClicked: (ev) ->
    @selectItem $(ev.currentTarget)
    analyticsTracker.weekView($el.data('week-id'), $el.index())

  calendarClicked: (ev) ->
    @selectItem $(ev.currentTarget)
    analyticsTracker.calendarView()

  selectItem: ($el) ->
    @$('.menu > *').removeClass 'selected'
    $el.addClass 'selected'

  getI18nValues: ->
    @t ['calendar_link']
