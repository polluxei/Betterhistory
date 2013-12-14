class BH.Presenters.GroupedVisitsPresenter extends BH.Presenters.Base
  constructor: (@collection) ->

  groupedVisits: ->
    for model in @collection.models
      presenter = new BH.Presenters.GroupedVisitPresenter(model)
      presenter.groupedVisit()
