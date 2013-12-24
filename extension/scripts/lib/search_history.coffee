class BH.Lib.SearchHistory extends EventEmitter
  constructor: (@query) ->
    @history = new BH.Chrome.History()

  fetch: ->
    options =
      text: @query
      searching: true

    @history.query options, (history) =>
      @trigger 'query:complete', [history]

  destroy: ->
    @fetch()
    @on 'query:complete', (history) =>
      for visit in history
        @history.deleteUrl visit.url
      @trigger 'destroy:complete'
