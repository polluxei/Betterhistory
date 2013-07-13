class BH.Models.WeekHistory extends BH.Models.History
  @include BH.Modules.I18n
  @include BH.Modules.Worker

  initialize: ->
    @chromeAPI = chrome
    @historyQuery = new BH.Lib.HistoryQuery(@chromeAPI)

  sync: (method, model, options) ->
    switch method
      when 'read'
        @historyQuery.run @toChrome(), (results) =>
          @preparse(results, options.success)

      when 'delete'
        @chromeAPI.history.deleteRange @toChrome(false), =>
          @set history: {}

  toChrome: (reading = true)->
    properties = startTime: @sod(), endTime: @eod()
    properties.text = '' if reading
    properties

  toTemplate: ->
    total: @totalVisits()
    days:
      for day, visits of @get('history')
        count: visits.length
        day: day
        percentage: "#{@dayVisitPercentage day}%"

  sod: ->
    new Date(@get('startDate').sod()).getTime()

  eod: ->
    new Date(@get('endDate').eod()).getTime()

  dayVisits: ->
    for day, visits of @get('history')
      visits.length if visits?

  totalVisits: ->
    return 0 if @dayVisits().length == 0
    @dayVisits().reduce (sum, num) ->
      sum + num

  dayVisitPercentage: (day) ->
    largest = Math.max.apply(Math, @dayVisits()) || 0
    return 0 if largest == 0
    @get('history')[day].length / largest * 100

  preparse: (results, callback) ->
    @worker 'dayGrouper', visits: results, (history) ->
      callback history

  parse: (data) ->
    history: data
