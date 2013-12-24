class BH.Chrome.History
  constructor: (@chromeAPI = chrome) ->

  query: (options, callback) ->
    @chromeAPI.history.search options, (visits) =>
      for visit in visits
        visit.date = new Date(visit.lastVisitTime)
        visit.extendedDate = moment(visit.date).format(@chromeAPI.i18n.getMessage('extended_formal_date'))
        visit.time = moment(visit.date).format(@chromeAPI.i18n.getMessage('local_time'))

      callback(visits)

  deleteAll: (callback) ->
    @chromeAPI.history.deleteAll ->
      callback()

  deleteUrl: (url) ->
    throw "Url needed" unless url?

    @chromeAPI.history.deleteUrl url: url

  deleteRange: (range, callback) ->
    throw "Start time needed" unless range.startTime?
    throw "End time needed" unless range.endTime?

    @chromeAPI.history.deleteRange range, => callback()
