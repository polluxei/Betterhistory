class BH.Chrome.WeekHistory extends EventEmitter
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date = new Date(date.getTime() + (6 * 86400000))
    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @historyQuery = new BH.Lib.HistoryQuery(@chromeAPI)
    @worker = BH.Modules.Worker.worker

  fetch: ->
    options =
      startTime: @startTime
      endTime: @endTime
      text: ''

    @historyQuery.run options, (results) =>
      @worker 'dayGrouper', visits: results, (history) =>
        @trigger 'query:complete', [history]

  destroy: ->
    options =
      startTime: @startTime
      endTime: @endTime

    chrome.history.deleteRange options, =>
      @trigger 'destroy:complete', [history]
