class BH.Lib.HistoryQuery extends BH.Base
  @include BH.Modules.Worker
  @include BH.Modules.I18n

  constructor: ->
    @chromeAPI = chrome

  run: (@options, callback) ->
    if @options.text
      @text = @options.text
      @options.text = ''

    options = {}
    _.extend(options, @options)
    if @options.searching?
      _.extend(options, @searchOptions)
    else
      options.maxResults = 5000
    delete options.searching

    @chromeAPI.history.search options, (results) =>
      @searchHandler(results, callback)

  searchHandler: (results, callback) ->
    @options.text = @text if @text
    results = @_prepareResults(results)
    @_sanitizeResults(results, callback)

  _sanitizeResults: (results, callback) ->
    options =
      options: @options
      results: results
    @worker('sanitizer', options, callback)

  _prepareResults: (results) ->
    _(results).each (result) =>
      result.date = new Date(result.lastVisitTime)
      # Translate dates and times here for the search sanitizer
      result.extendedDate = moment(result.date).format(@t('extended_formal_date'))
      result.time = moment(result.date).format(@t('local_time'))
    results

  searchOptions:
    startTime: 0
    maxResults: 0
