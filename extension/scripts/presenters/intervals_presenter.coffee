class BH.Presenters.IntervalsPresenter extends BH.Presenters.Base
  intervals: ->
    intervals = for model in @models
      presenter = new BH.Presenters.IntervalPresenter(model)
      presenter.interval()

    intervals: intervals
