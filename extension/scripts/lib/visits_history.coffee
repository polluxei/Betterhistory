class BH.Lib.VisitsHistory
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

      @worker 'rangeSanitizer', options, (history) =>
        callback history

  destroy: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime

    @history.deleteRange options, =>
      callback()
