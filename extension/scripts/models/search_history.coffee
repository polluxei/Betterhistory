class BH.Models.SearchHistory extends BH.Models.History
  @include BH.Modules.I18n

  initialize: ->
    @historyQuery = new BH.Lib.HistoryQuery(@chromeAPI)

  sync: (method, model, options) ->
    if method == 'read'
      @historyQuery.run @toChrome(), (history) ->
        options.success(history)

  toTemplate: (start, end) ->
    @get('history').toTemplate(start, end)

  toChrome: ->
    text: @get('query')
    searching: true

  parse: (data) ->
    visits = new BH.Collections.Visits()

    for visit in data
      visits.add(new BH.Models.Visit(visit))

    history: visits
