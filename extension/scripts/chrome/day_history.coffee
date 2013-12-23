class BH.Chrome.DayHistory extends EventEmitter
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @historyQuery = new BH.Lib.HistoryQuery(@chromeAPI)
    @worker = BH.Modules.Worker.worker

  fetch: ->
    options =
      startTime: @startTime
      endTime: @endTime
      text: ''
      maxResults: 5000

    chrome.history.search options, (results) =>
      options =
        options: options
        results: results

      @worker 'rangeSanitizer', options, (sanitizedResults) =>
        options.results = sanitizedResults
        @worker 'timeGrouper', options, (history) =>
          if settings.get('domainGrouping')
            options = intervals: history
            @worker 'domainGrouper', options, (history) =>
              @trigger 'query:complete', [history]
          else
            @trigger 'query:complete', [history]

  destroy: ->
    options =
      startTime: @startTime
      endTime: @endTime

    chrome.history.deleteRange options, =>
      @trigger 'destroy:complete'
