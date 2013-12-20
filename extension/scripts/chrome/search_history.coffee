class BH.Chrome.SearchHistory extends EventEmitter
  constructor: (@query) ->
    @historyQuery = new BH.Lib.HistoryQuery(chrome)

  fetch: ->
    options =
      text: @query
      searching: true

    @historyQuery.run options, (history) =>
      @trigger 'query:complete', [history]

  destroy: ->
    @fetch()
    @on 'query:complete', (history) ->
      for visit in history
        chrome.history.deleteUrl url: visit.url
      @trigger 'destroy:complete'
