class BH.Lib.DayHistory
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @history = new BH.Chrome.History()
    @worker = BH.Modules.Worker.worker

  fetch: (callback = ->) ->
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
        options =
          visits: sanitizedResults
          interval: settings.get('timeGrouping')

        @worker 'timeGrouper', options, (history) =>
          if settings.get('domainGrouping')
            options = intervals: history
            @worker 'domainGrouper', options, (history) =>
              callback history
          else
            callback history

  destroy: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime

    @history.deleteRange options, =>
      callback()
