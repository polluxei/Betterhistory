class BH.Presenters.VisitsPresenter
  hoursDistribution: (visits) ->
    out = {}
    for visit in visits
      hour = new Date(visit.lastVisitTime).getHours()
      out[hour] = true
    out

  visitsByHour: (visits) ->
    out = for hour in [0..23]
      date = new Date()
      date.setHours(hour)
      date.setMinutes(0)
      hour: hour
      hour_label: moment(date).format('h:mm A')
      visits: []

    for visit in visits
      hour = new Date(visit.lastVisitTime).getHours()
      out[hour].visits.push visit

    _.reject out, (item) -> item.visits.length == 0
