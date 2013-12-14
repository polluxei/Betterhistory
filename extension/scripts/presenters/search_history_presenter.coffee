class BH.Presenters.SearchHistoryPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  history: (start, end) ->
    presenter = new BH.Presenters.VisitsPresenter(@model.get('history'))
    presenter.visits(start, end)
