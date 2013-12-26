class BH.Presenters.DayHistoryPresenter extends BH.Presenters.Base
  constructor: (@collection) ->

  history: ->
    out = []
    for model in @collection.models
      interval =
        amount: @t('number_of_visits', [
          model.get('visits').length.toString(),
          '<span class="amount">',
          '</span>'
        ])
        time: moment(model.get('datetime')).format('LT')
        id: model.id
        visits: []

      for visit in model.get('visits').models
        if visit.get('isGrouped')
          groupedVisits = for groupedVisit in visit.visits
            visitData(groupedVisit)

          interval.visits.push groupedVisits
        else
          interval.visits.push visitData(visit)

      out.push interval

    history: out

visitData = (visit) ->
  _.extend visit.toJSON(),
    isGrouped: false
    host: visit.domain()
    path: visit.path()
