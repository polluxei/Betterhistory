class BH.Models.Day extends Backbone.Model
  initialize: ->
    @set id: moment(@get('date')).id()

  parseAndSet: (data) ->
    intervals = new BH.Collections.Intervals()

    for interval in data
      visits = new BH.Collections.Visits()
      for visit in interval.visits
        if _.isArray(visit)
          visits.add(new BH.Models.GroupedVisit(visit))
        else
          visits.add(new BH.Models.Visit(visit))

      intervals.add {
        id: interval.id
        datetime: interval.datetime
        visits: visits
      }

    @set history: intervals
