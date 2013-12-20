class BH.Presenters.WeekHistoryPresenter extends BH.Presenters.Base
  constructor: (@collection) ->

  history: ->
    dayVisitPercentage = (model) =>
      largest = Math.max.apply(Math, @dayVisits()) || 0
      return 0 if largest == 0
      model.get('visits').length / largest * 100

    total: @totalVisits()
    days:
      for model in @collection.models
        out =
          count: model.get('visits').length
          day: model.get('name')
          percentage: "#{dayVisitPercentage(model)}%"

  dayVisits: ->
    for model in @collection.models
      model.get('visits').length

  totalVisits: ->
    return 0 if @dayVisits().length == 0
    @dayVisits().reduce (sum, num) ->
      sum + num
