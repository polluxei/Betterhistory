class BH.Models.DayHistory extends BH.Models.History
  @include BH.Modules.I18n
  @include BH.Modules.Worker

  initialize: (attrs, options) ->
    @chromeAPI = chrome
    @historyQuery = new BH.Lib.HistoryQuery(@chromeAPI)

  sync: (method, model, options) ->
    switch method
      when 'read'
        @set history: [], silent: true # so change is always fired
        @historyQuery.run @toChrome(), (history) =>
          @preparse(history, options.success)

      when 'delete'
        @chromeAPI.history.deleteRange @toChrome(false), =>
          @set history: @defaults.history

  toChrome: (reading = true) ->
    properties = startTime: @sod(), endTime: @eod()
    properties.text = '' if reading
    properties

  sod: ->
    new Date(@get('date').sod()).getTime()

  eod: ->
    new Date(@get('date').eod()).getTime()

  preparse: (results, callback) ->
    options =
      visits: results
      interval: settings.get 'timeGrouping'

    @worker 'timeGrouper', options, (history) =>
      if settings.get('domainGrouping')
        options = intervals: history
        @worker 'domainGrouper', options, (history) ->
          callback(history)
      else
        callback(history)


  parse: (data) ->
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

    history: intervals
