class BH.Chrome.History
  constructor: (@chromeAPI = chrome) ->

  query: (options, callback = ->) ->
    @chromeAPI.history.search options, (visits) =>
      for visit in visits
        visit.date = new Date(visit.lastVisitTime)
        visit.extendedDate = visit.date.toLocaleString()

      callback(visits)

  deleteAll: (callback = ->) ->
    @chromeAPI.history.deleteAll ->
      callback()

  deleteUrl: (url, callback = ->) ->
    throw "Url needed" unless url?

    @chromeAPI.history.deleteUrl url: url, ->
      callback()

  deleteRange: (range, callback = ->) ->
    throw "Start time needed" unless range.startTime?
    throw "End time needed" unless range.endTime?

    @chromeAPI.history.deleteRange range, => callback()
