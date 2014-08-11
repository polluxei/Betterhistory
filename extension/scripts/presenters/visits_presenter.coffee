class BH.Presenters.VisitsPresenter
  hoursDistribution: (visits) ->
    out = {}
    for visit in visits
      hour = new Date(visit.lastVisitTime).getHours()
      out[hour] = true
    out
