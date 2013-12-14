class BH.Presenters.IntervalPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  interval: ->
    properties =
      amount: @t('number_of_visits', [
        @model.get('visits').length.toString(),
        '<span class="amount">',
        '</span>'
      ])
      time: moment(@model.get('datetime')).format('LT')
      id: @model.id

    presenter = new BH.Presenters.VisitsPresenter @model.get('visits')
    _.extend properties, presenter.visits()
