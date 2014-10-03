class BH.Views.TimelineView extends BH.Views.MainView
  template: BH.Templates['timeline']

  events:
    'click a.date': 'onDateClicked'
    'click a.next': 'onNextClicked'
    'click a.previous': 'onPreviousClicked'

  initialize: ->

    @state = new Backbone.Model
      startDate: moment(new Date()).startOf('day').toDate()

    @state.on 'change:startDate', @onStartDateChanged, @

  render: ->
    @$el.html ''

    timelinePresenter = new BH.Presenters.Timeline(@model.toJSON())
    @$el.append Mustache.to_html @template, timelinePresenter.timeline(@state.get('startDate'))

    @

  onStartDateChanged: ->
    @render()

  onDateClicked: (ev) ->
    @$('a').removeClass('selected')
    $(ev.currentTarget).addClass('selected')

  onNextClicked: (ev) ->
    ev.preventDefault()

    unless $(ev.currentTarget).hasClass('disabled')
      date = moment(@state.get('startDate')).add('days', 7)
      @state.set startDate: date.startOf('day').toDate()

  onPreviousClicked: (ev) ->
    ev.preventDefault()

    unless $(ev.currentTarget).hasClass('disabled')
      date = moment(@state.get('startDate')).subtract('days', 7)
      @state.set startDate: date.startOf('day').toDate()
