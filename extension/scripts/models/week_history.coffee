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

  sod: ->
    new Date(@get('startDate').sod()).getTime()

  eod: ->
    new Date(@get('endDate').eod()).getTime()

  preparse: (results, callback) ->
    @worker 'dayGrouper', visits: results, (history) ->
      callback history

  parse: (data) ->
    history: data
