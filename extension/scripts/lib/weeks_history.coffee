class BH.Lib.WeeksHistory extends EventEmitter
  constructor: ->
    @history = new BH.Chrome.History()

  fetch: ->
    options =
      startTime: 0
      maxResults: 0
      endTime: new Date().getTime()
      text: ''

    @history.run options, (history) =>
      options =
        visits: history
        config: startingWeekDay: settings.get('startingWeekDay')
      BH.Modules.Worker.worker 'weekGrouper', options, (history) =>
        @trigger 'query:complete', [history]

  destroy: ->
    @history.deleteAll =>
      @trigger 'destroy:complete'
