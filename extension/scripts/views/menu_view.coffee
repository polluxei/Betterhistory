class BH.Views.MenuView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['menu']

  events:
    'click .menu > .week': 'weekClicked'
    'click .menu > .calendar': 'calendarClicked'

  initialize: ->
    @chromeAPI = chrome

  render: ->
    presenter = new BH.Presenters.WeeksPresenter(@collection)
    properties = _.extend {}, @getI18nValues(), presenter.weeks()

    html = Mustache.to_html @template, properties
    @$el.html html

  weekClicked: (ev) ->
    @$('.menu > *').removeClass 'selected'
    $el = $(ev.currentTarget)
    $el.addClass 'selected'
    analyticsTracker.weekView($el.data('week-id'), $el.index())

  calendarClicked: (ev) ->
    @$('.menu > *').removeClass 'selected'
    $el = $(ev.currentTarget)
    $el.addClass 'selected'
    analyticsTracker.calendarView()

  getI18nValues: ->
    @t ['calendar_link']
