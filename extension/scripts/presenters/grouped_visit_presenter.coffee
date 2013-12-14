class BH.Presenters.GroupedVisitPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  groupedVisit: ->
    presenter = new BH.Presenters.VisitsPresenter(@model.visits)
    _.extend @model.toJSON(), groupedVisits: presenter.visits().visits
