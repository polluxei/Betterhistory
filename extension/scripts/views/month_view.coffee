class BH.Views.MonthView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['month']

  events:
    'click .week': 'onWeekClicked'

  render: ->
    presenter = new BH.Presenters.CalendarPresenter(@model.toJSON())
    calendar = presenter.calendar()

    properties = _.extend {}, @model.toJSON(), weeks: calendar
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onWeekClicked: (ev) ->
    ev.preventDefault()
    weekId = $(ev.currentTarget).data('week-id')
    router.navigate("weeks/#{weekId}", trigger: true)
