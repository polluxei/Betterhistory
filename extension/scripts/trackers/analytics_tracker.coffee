class BH.Trackers.AnalyticsTracker
  constructor: ->
    throw "Analytics not set" unless _gaq?

  trackEvent: (params) ->
    params.unshift('_trackEvent')
    @track(params)

  pageView: (url) ->
    # Don't track what people search for
    url = 'search' if url.match(/search/)
    @track(['_trackPageview', "/#{url}"])

  track: (params) ->
    _gaq.push(params)

  historyOpen: ->
    @trackEvent(['History', 'Open'])

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

  tagDetailsPopupClick: ->
    @trackEvent(['Popup', 'Tag Details Click'])

  viewAllHistoryPopupClick: ->
    @trackEvent(['Popup', 'View all History Click'])

  howToTagClick: ->
    @trackEvent(['Tags', 'How to Tag Click'])

  deleteAllTagsClick: ->
    @trackEvent(['Tags', 'Delete all Click'])

  siteTagDrag: ->
    @trackEvent(['Tag', 'Site Drag'])

  siteTagDrop: ->
    @trackEvent(['Tag', 'Site Drop'])

  renameTagClick: ->
    @trackEvent(['Tag', 'Rename Click'])

  deleteTagClick: ->
    @trackEvent(['Tag', 'Delete Tag Click'])

  tagAdded: ->
    @trackEvent(['Tag', 'Added'])

  tagRemoved: ->
    @trackEvent(['Tag', 'Removed'])

  tagRenamed: ->
    @trackEvent(['Tag', 'Renamed'])

  siteTagged: ->
    @trackEvent(['Site', 'Tagged'])

  siteUntagged: ->
    @trackEvent(['Site', 'Untagged'])

  shareClicked: ->
    @trackEvent(['Tag', 'Shared'])

  getStartedSyncingModalSeen: ->
    @trackEvent(['Get Started Modal', 'Seen'])

  getStartedSyncingContinueClicked: ->
    @trackEvent(['Get Started Modal', 'Continue Click'])

  getStartedSyncingCancelClicked: ->
    @trackEvent(['Get Started Modal', 'Cancel Click'])

  syncPurchaseSuccess: ->
    @trackEvent(['Sync', 'Purchased', 'Success'])

  syncPurchaseFailure: ->
    @trackEvent(['Sync', 'Purchased', 'Failure'])

  syncDecisionModalSeen: ->
    @trackEvent(['Sync Decision Modal', 'Seen'])

  syncAutomaticModalSeen: ->
    @trackEvent(['Sync Automatic Modal', 'Seen'])

  userLoggedIn: ->
    @trackEvent(['User', 'Log In'])

  userLoggedOut: ->
    @trackEvent(['User', 'Log Out'])

  userCreationFailure: ->
    @trackEvent(['User', 'Creation', 'Failure'])

  userCreationSuccess: ->
    @trackEvent(['User', 'Creation', 'Success'])

  userOAuthFailure: ->
    @trackEvent(['User', 'OAuth', 'Failure'])

  userOAuthSuccess: ->
    @trackEvent(['User', 'OAuth', 'Success'])

  ensureDatetimeOnTaggedSitesMigration: ->
    @trackEvent(['Migration', 'ensure_datetime_on_tagged_sites'])
