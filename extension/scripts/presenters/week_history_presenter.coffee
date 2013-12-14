class BH.Presenters.WeekHistoryPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  history: ->
    dayVisitPercentage = (day) =>
      largest = Math.max.apply(Math, dayVisits()) || 0
      return 0 if largest == 0
      @model.get('history')[day].length / largest * 100

    totalVisits = =>
      return 0 if dayVisits().length == 0
      dayVisits().reduce (sum, num) ->
        sum + num

    dayVisits = =>
      for day, visits of @model.get('history')
        visits.length if visits?

    total: totalVisits()
    days:
      for day, visits of @model.get('history')
        out =
          count: visits.length
          day: day
          percentage: "#{dayVisitPercentage day}%"
