class BH.Chrome.WeekHistory extends EventEmitter
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date = new Date(date.getTime() + (6 * 86400000))
    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @chromeAPI = chrome
    @worker = BH.Modules.Worker.worker

  fetch: ->
    options =
      startTime: @startTime
      endTime: @endTime
      text: ''
      maxResults: 5000

    @chromeAPI.history.search options, (results) =>
      options =
        options: options
        results: results

      @worker 'rangeSanitizer', options, (sanitizedResults) =>
        @worker 'dayGrouper', visits: sanitizedResults, (history) =>
          @trigger 'query:complete', [history]

  destroy: ->
    options =
      startTime: @startTime
      endTime: @endTime

    @chromeAPI.history.deleteRange options, =>
      @trigger 'destroy:complete'
