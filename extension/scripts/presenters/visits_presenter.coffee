class BH.Presenters.VisitsPresenter
  hoursDistribution: (visits) ->
    hours = {}
    for visit in visits
      hour = new Date(visit.lastVisitTime).getHours()
      hours[hour] = true

    [
      {label: 12, enabled: hours['0'], value: '0'}
      {label: 1, enabled: hours['1'], value: '1'}
      {label: 2, enabled: hours['2'], value:'2'}
      {label: 3, enabled: hours['3'], value: '3'}
      {label: 4, enabled: hours['4'], value: '4'}
      {label: 5, enabled: hours['5'], value: '5'}
      {label: 6, enabled: hours['6'], value: '6'}
      {label: 7, enabled: hours['7'], value: '7'}
      {label: 8, enabled: hours['8'], value: '8'}
      {label: 9, enabled: hours['9'], value: '9'}
      {label: 10, enabled: hours['10'], value: '10'}
      {label: 11, enabled: hours['11'], value: '11'}
      {label: 12, enabled: hours['12'], value: '12'}
      {label: 1, enabled: hours['13'], value: '13'}
      {label: 2, enabled: hours['14'], value: '14'}
      {label: 3, enabled: hours['15'], value: '15'}
      {label: 4, enabled: hours['16'], value: '16'}
      {label: 5, enabled: hours['17'], value: '17'}
      {label: 6, enabled: hours['18'], value: '18'}
      {label: 7, enabled: hours['19'], value: '19'}
      {label: 8, enabled: hours['20'], value: '20'}
      {label: 9, enabled: hours['21'], value: '21'}
      {label: 10, enabled: hours['22'], value: '22'}
      {label: 11, enabled: hours['23'], value: '23'}
    ].reverse()

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
