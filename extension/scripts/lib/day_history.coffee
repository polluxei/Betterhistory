class BH.Lib.DayHistory extends EventEmitter
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @history = new BH.Chrome.History()
    @worker = BH.Modules.Worker.worker

  fetch: ->
    options =
      startTime: @startTime
      endTime: @endTime
      text: ''
      maxResults: 5000

    @history.query options, (results) =>
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

    @history.deleteRange options, =>
      @trigger 'destroy:complete'
