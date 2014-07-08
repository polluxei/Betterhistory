class BH.Views.TimelineView extends BH.Views.MainView
  className: 'timeline_view'

  template: BH.Templates['timeline']

  events:
    'click a.date': 'onDateClicked'
    'click a.next': 'onNextClicked'
    'click a.previous': 'onPreviousClicked'

  initialize: ->
    @model.on 'change:date', @onDateChanged, @

  render: ->
    @$el.html ''

    getLabel = (date) ->
      return 'Today' if moment().startOf('day').isSame(date)
      return 'Yesterday' if moment().subtract('days', 1).startOf('day').isSame(date)
      date.format('dddd')

    dates = for i in [0..6]
      date = moment(@model.get('date')).startOf('day').subtract 'days', i
      label: getLabel(date)
      date: "#{date.format('MMM D')}#{date.format('Do')}"
      selected: true if date.isSame(@model.get('date'))
      id: date.format('M-D-YY')

    html = Mustache.to_html @template, dates: dates
    @$el.append html
    @

  onDateChanged: ->
    @render()

  onDateClicked: (ev) ->
    @$('a').removeClass('selected')
    $(ev.currentTarget).addClass('selected')

  onNextClicked: (ev) ->
    ev.preventDefault()
    date = moment(@model.get('date')).add('days', 7)
    @model.set date: date.toDate()

  onPreviousClicked: (ev) ->
    ev.preventDefault()
    date = moment(@model.get('date')).subtract('days', 7)
    @model.set date: date.toDate()
