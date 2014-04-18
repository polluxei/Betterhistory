class BH.Views.MonthView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['month']

  events:
    'click .selected': 'onWeekClicked'
    'mouseover td': 'onDayMouseOver'
    'mouseout td': 'onDayMouseOut'
    'click .previous_month': 'onPreviousMonthClick'
    'click .next_month': 'onNextMonthClick'

  render: ->
    presenter = new BH.Presenters.CalendarPresenter(@model.toJSON())
    properties = _.extend {}, @getI18nValues(), presenter.calendar()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onWeekClicked: (ev) ->
    ev.preventDefault()
    weekId = @$('.selected').first().data('week-id')
    router.navigate("weeks/#{weekId}", trigger: true)

  onPreviousMonthClick: (ev) ->
    ev.preventDefault()
    date = @model.get('monthDate')
    date.setMonth(date.getMonth() - 1)
    @model.set monthDate: date
    @render()

  onNextMonthClick: (ev) ->
    ev.preventDefault()
    date = @model.get('monthDate')
    date.setMonth(date.getMonth() + 1)
    @model.set monthDate: date
    @render()

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

  getI18nValues: ->
    properties = @t [
      'sunday_short',
      'monday_short',
      'tuesday_short',
      'wednesday_short',
      'thursday_short',
      'friday_short',
      'saturday_short'
    ]
    properties['i18n_previous_month_link'] = @t('previous_month_link', [
      @t('back_arrow')
    ])
    properties['i18n_next_month_link'] = @t('next_month_link', [
      @t('forward_arrow')
    ])
    properties


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
