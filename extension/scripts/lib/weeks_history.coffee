class BH.Lib.WeeksHistory
  constructor: ->
    @history = new BH.Chrome.History()

  fetch: (callback = ->) ->
    options =
      startTime: 0
      maxResults: 0
      endTime: new Date().getTime()
      text: ''

    @history.query options, (history) =>
      options =
        visits: history
        config: startingWeekDay: settings.get('startingWeekDay')
      BH.Modules.Worker.worker 'weekGrouper', options, (history) =>
        callback history

  destroy: (callback = ->) ->
    @history.deleteAll =>
      callback()
