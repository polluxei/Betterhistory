@BH = BH ? {}
BH.Workers = BH.Workers ? {}

class BH.Workers.DayGrouper
  constructor: ->
    @weekDays =
      Sunday: []
      Monday: []
      Tuesday: []
      Wednesday: []
      Thursday: []
      Friday: []
      Saturday: []

  run: (visits) ->
    for visit in visits
      day = new Date(visit.lastVisitTime).getDay()
      @weekDays[@indexToDay(day)].push visit
    @weekDays

  indexToDay: (index) ->
    days = for own day of @weekDays
      day
    days[index]

unless onServer?
  self.addEventListener 'message', (e) ->
    dayGrouper = new BH.Workers.DayGrouper()
    postMessage dayGrouper.run(e.data.visits)
