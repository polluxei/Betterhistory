class BH.Lib.SearchHistory
  constructor: (@query) ->
    @history = new BH.Chrome.History()

  fetch: (callback = ->) ->
    options =
      text: @query
      searching: true

    @history.query options, (history) =>
      callback history

  destroy: (callback = ->) ->
    @fetch()
    @on 'query:complete', (history) =>
      for visit in history
        @history.deleteUrl visit.url
      callback()
