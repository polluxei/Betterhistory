class BH.Presenters.DayPresenter
  constructor: (@day) ->

  dayInfo: ->
    date = moment(@day.date)
    weekId = startingWeekDate(date).id()

    properties =
      title: date.format('dddd')
      formalDate: date.format('LLL')
      weekUrl: "#weeks/#{weekId}"
      filter: JSON.stringify(day: @day.id)

    _.extend properties, @day

startingWeekDate = (date) ->
  moment(date).past(settings.get('startingWeekDay'), 0)
