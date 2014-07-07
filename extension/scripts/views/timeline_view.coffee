class BH.Views.TimelineView extends BH.Views.MainView
  className: 'timeline_view'

  template: BH.Templates['timeline']

  events:
    'click a.date': 'onDateClicked'
    'click a.next': 'onNextClicked'
    'click a.previous': 'onPreviousClicked'

  render: ->
    dates = for i in [0..6]
      date = moment().startOf('day').subtract 'days', i
      label: date.format('dddd')
      date: "#{date.format('MMM D')}#{date.format('Do')}"
      selected: true if date.isSame(@model.get('date'))
      id: date.format('M-D-YY')

    html = Mustache.to_html @template, dates: dates
    @$el.append html
    @

  onDateClicked: (ev) ->
    @$('a').removeClass('selected')
    $(ev.currentTarget).addClass('selected')

  onNextClicked: (ev) ->
    ev.preventDefault()
    console.log 'next'

  onPreviousClicked: (ev) ->
    ev.preventDefault()
    console.log 'prev'
