class BH.Presenters.VisitPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  visit: ->
    _.extend
      isGrouped: false
      host: @model.domain()
      path: @model.path()
    , @model.toJSON()
