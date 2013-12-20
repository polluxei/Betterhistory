class BH.Presenters.VisitsPresenter extends BH.Presenters.Base
  constructor: (@collection) ->

  visits: (start, end)->
    visits = []

    if start? && end?
      for i in [start...end]
        if @collection.models?[i]?
          presenter = new BH.Presenters.VisitPresenter(@collection.models[i])
          visits.push presenter.visit()
    else
      for model in @collection.models
        if model.get('isGrouped')
          presenter = new BH.Presenters.GroupedVisitPresenter(model)
          visits.push presenter.groupedVisit()
        else
          presenter = new BH.Presenters.VisitPresenter(model)
          visits.push presenter.visit()

    visits: visits
