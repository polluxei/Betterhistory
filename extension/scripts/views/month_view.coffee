class BH.Views.MonthView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['month']

  events:
    'click .selected': 'onWeekClicked'
    'mouseover td': 'onDayMouseOver'
    'mouseout td': 'onDayMouseOut'

  render: ->
    presenter = new BH.Presenters.CalendarPresenter(@model.toJSON())
    calendar = presenter.calendar()

    properties = _.extend {}, @model.toJSON(), weeks: calendar
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onWeekClicked: (ev) ->
    ev.preventDefault()
    weekId = @$('.selected').first().data('week-id')
    router.navigate("weeks/#{weekId}", trigger: true)

  onDayMouseOver: (ev) ->
    @$('.selected').removeClass('selected')
    startingWeekDay = settings.get('startingWeekDay').toLowerCase()

    $el = $(ev.currentTarget)
    $el.addClass('selected')
    highlightedDays = 1

    return if $el.data('day') == ''
    if $el.data('day').toLowerCase() == startingWeekDay
      highlightForward($el, highlightedDays)
    else
      highlightedDays = highlightBackward(startingWeekDay, $el)
      highlightForward($el, highlightedDays)

  onDayMouseOut: ->
    @$('.selected').removeClass('selected')


highlightBackward = (startingWeekDay, $el) ->
  highlightedDays = 1
  while $el.data('day').toLowerCase() != startingWeekDay
    if $el.is(':first-child')
      $el = $el.parent().prev().children().last()
    else
      $el = $el.prev()

    $el.addClass('selected')
    highlightedDays += 1
  highlightedDays

highlightForward = ($el, highlightedDays) ->
  while highlightedDays < 7
    if $el.is(':last-child')
      $el = $el.parent().next().children().first()
    else
      $el = $el.next()
    $el.addClass('selected')
    highlightedDays += 1
