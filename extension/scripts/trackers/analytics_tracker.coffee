class BH.Trackers.AnalyticsTracker
  constructor: (analytics) ->
    throw "Analytics not set" unless analytics?

    @analytics = analytics

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

  syncStorageError: (operation, msg) ->
    @trackEvent(['Storage Error', operation, 'Sync', msg])

  syncStorageAccess: (operation) ->
    @trackEvent(['Storage Access', operation, 'Sync'])

  localStorageError: (operation, msg) ->
    @trackEvent(['Storage Error', operation, 'Local', msg])

  mailingListPrompt: ->
    @trackEvent(['Mailing List Prompt', 'Seen'])

  popupVisible: ->
    @trackEvent(['Popup', 'Seen'])

  exploreTagsPopupClick: ->
    @trackEvent(['Popup', 'Explore Tags Click'])

  searchByDomainPopupClick: ->
    @trackEvent(['Popup', 'Search by Domain Click'])

  viewAllHistoryPopupClick: ->
    @trackEvent(['Popup', 'View all History Click'])

  addTagPopup: ->
    @trackEvent(['Popup', 'Add Tag'])

  removeTagPopup: ->
    @trackEvent(['Popup', 'Remove Tag'])

  tagPopupClick: ->
    @trackEvent(['Popup', 'Tag Click'])

  trackEvent: (params) ->
    params.unshift('_trackEvent')
    @analytics.push(params)


