class BH.Presenters.DayHistoryPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  history: ->
    history: @model.get('history').map (interval) ->
      presenter = new BH.Presenters.IntervalPresenter(interval)
      presenter.interval()
