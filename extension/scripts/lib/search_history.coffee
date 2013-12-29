class BH.Lib.SearchHistory
  constructor: (@query) ->
    @history = new BH.Chrome.History()

  fetch: (callback = ->) ->
    options =
      text: @query
      startTime: 0
      maxResults: 0

    @history.query options, (history) =>
      callback parse(history)

  destroy: (callback = ->) ->
    @fetch (history) =>
      for visit in history
        @history.deleteUrl visit.url
      callback()

parse = (visits) ->
  for visit in visits
    fillInVisit(visit)

fillInVisit = (visit) ->
  visit.host = getDomain(visit.url)
  visit.location = visit.url
  visit.path = visit.url.replace(visit.domain, '')
  visit.title = '(No Title)' if visit.title == ''
  visit

getDomain = (url) ->
  match = url.match(/\w+:\/\/(.*?)\//)
  if match == null then null else match[0]
