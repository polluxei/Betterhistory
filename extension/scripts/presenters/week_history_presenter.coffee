class BH.Presenters.WeekHistoryPresenter extends BH.Presenters.Base
  constructor: (@days) ->

  history: ->
    dayVisitPercentage = (day) =>
      largest = Math.max.apply(Math, @dayVisits()) || 0
      return 0 if largest == 0
      day.visits.length / largest * 100

    total: @totalVisits()
    days:
      for day in @days
        out =
          count: day.visits.length
          day: day.name
          percentage: "#{dayVisitPercentage(day)}%"

  dayVisits: ->
    for day in @days
      day.visits.length

  totalVisits: ->
    return 0 if @dayVisits().length == 0
    @dayVisits().reduce (sum, num) ->
      sum + num
