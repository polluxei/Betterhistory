class BH.Presenters.AllWeeksPresenter extends BH.Presenters.Base
  constructor: (@collection) ->

  allWeeks: ->
    weeks = for model in @collection.models
      out =
        shortTitle: moment(model.get('date')).format('L')
        visitCount: model.get('visits').length
        url: "#weeks/#{moment(model.get('date')).id()}"

    weeks: weeks

  totalVisits: ->
    out = 0
    for model in @collection.models
      out += model.get('visits').length
    out
