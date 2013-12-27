class BH.Presenters.DayHistoryPresenter extends BH.Presenters.Base
  constructor: (@intervals) ->

  history: ->
    out = []
    for interval in @intervals
      preppedInterval =
        amount: @t('number_of_visits', [
          interval.visits.length.toString(),
          '<span class="amount">',
          '</span>'
        ])
        time: moment(interval.datetime).format('LT')
        id: interval.id
        visits: []

      for visit in interval.visits
        if visit.isGrouped
          groupedVisits = for groupedVisit in visit.visits
            visitData(groupedVisit)

          preppedInterval.visits.push _.extend(visit, groupedVisits: groupedVisits)
        else
          preppedInterval.visits.push visitData(visit)

      out.push preppedInterval

    history: out

visitData = (visit) ->
  _.extend visit,
    isGrouped: false
