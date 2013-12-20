class BH.Presenters.DayPresenter
  constructor: (model) ->
    @model = model

  day: ->
    date = moment(@model.get('date'))
    weekId = startingWeekDate(date).id()

    properties =
      title: date.format('dddd')
      formalDate: date.format('LLL')
      weekUrl: "#weeks/#{weekId}"

    _.extend properties, @model.toJSON()

startingWeekDate = (date) ->
  moment(date).past(settings.get('startingWeekDay'), 0)
