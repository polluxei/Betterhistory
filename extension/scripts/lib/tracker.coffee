class BH.Lib.Tracker
  constructor: (analytics, page) ->
    throw "Analytics not set" unless analytics?
    throw "Window not set" unless page?

    @analytics = analytics

    page.onerror = (msg, url, lineNumber) =>
      @error(msg, url, lineNumber)

  pageView: (url) ->
    # Don't track what people search for
    url = 'search' if url.match(/search/)
    @analytics.push(['_trackPageview', "/#{url}"])

  weekView: (date, distanceFromCurrentWeek) ->
    @trackEvent(['Weeks', 'Click', date, distanceFromCurrentWeek])

  visitDeletion: ->
    @trackEvent(['Visit', 'Delete'])

  groupedVisitsDeletion: ->
    @trackEvent(['Grouped visits', 'Delete'])

  timeIntervalDeletion: ->
    @trackEvent(['Time interval', 'Delete'])

  dayVisitsDeletion: ->
    @trackEvent(['Day visits', 'Delete'])

  weekVisitsDeletion: ->
    @trackEvent(['Week visits', 'Delete'])

  searchResultsDeletion: ->
    @trackEvent(['Search results', 'Delete'])

  paginationClick: ->
    @trackEvent(['Pagination', 'Click'])

  omniboxSearch: ->
    @trackEvent(['Omnibox', 'Search'])

  browserActionClick: ->
    @trackEvent(['Browser action', 'Click'])

  contextMenuClick: ->
    @trackEvent(['Context menu', 'Click'])

  selectionContextMenuClick: ->
    @trackEvent(['Selection context menu', 'Click'])

  error: (msg, url, lineNumber) ->
    @trackEvent(['Error', msg, url, lineNumber])

  syncStorageError: (operation, msg) ->
    @trackEvent(['Storage Error', operation, 'Sync', msg])

  mailingListPrompt: ->
    @trackEvent(['Mailing List Prompt', 'Seen'])

  trackEvent: (params) ->
    params.unshift('_trackEvent')
    @analytics.push(params)


