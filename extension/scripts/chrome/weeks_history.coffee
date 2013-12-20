class BH.Chrome.WeeksHistory extends EventEmitter
  fetch: ->
    historyQuery = new BH.Lib.HistoryQuery()
    historyQuery.run {
      startTime: 0
      maxResults: 0
      endTime: new Date().getTime()
      text: ''
    }, (history) =>
      options =
        visits: history
        config: startingWeekDay: settings.get('startingWeekDay')
      BH.Modules.Worker.worker 'weekGrouper', options, (history) =>
        @trigger 'query:complete', [history]

  destroy: ->
    chrome.history.deleteAll =>
      @trigger 'destroy:complete'
