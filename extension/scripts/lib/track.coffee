class BH.Lib.Track
  constructor: (analytics) ->
    @analytics = analytics

  pageView: (url) ->
    # Don't track what people search for
    url = 'search' if url.match(/search/)
    @analytics.push(['_trackPageview', "/#{url}"])

  weekView: (date, distanceFromCurrentWeek) ->
    @trackEvent(['Weeks', 'Clicked', date, distanceFromCurrentWeek])

  visitDeletion: ->
    @trackEvent(['Delete', 'Clicked', 'visit'])

  groupedVisitDeletion: ->
    @trackEvent(['Delete', 'Clicked', 'grouped visit'])

  timeIntervalDeletion: ->
    @trackEvent(['Delete', 'Clicked', 'time interval'])

  dayVisitsDeletion: ->
    @trackEvent(['Delete', 'Clicked', 'day visits'])

  weekVisitsDeletion: ->
    @trackEvent(['Delete', 'Clicked', 'week visits'])

  searchResultsDeletion: ->
    @trackEvent(['Delete', 'Clicked', 'search results'])

  paginationClick: ->
    @trackEvent(['Pagination', 'Clicked'])

  error: (msg, url, lineNumber) ->
    @trackEvent(['Error', msg, url, lineNumber])

  trackEvent: (params) ->
    params.unshift('_trackEvent')
    @analytics.push(params)


