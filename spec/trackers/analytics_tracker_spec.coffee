describe 'BH.Trackers.AnalyticsTracker', ->
  beforeEach ->
    @analytics = push: jasmine.createSpy('push')
    @analyticsTracker = new BH.Trackers.AnalyticsTracker(@analytics)

  describe '#pageView', ->
    it 'tracks the current url fragment', ->
      @analyticsTracker.pageView('page/url')
      expect(@analytics.push).toHaveBeenCalledWith ['_trackPageview', '/page/url']

    it 'does not track the search term in a url', ->
      @analyticsTracker.pageView('search/term')
      expect(@analytics.push).toHaveBeenCalledWith ['_trackPageview', '/search']

  describe '#weekView', ->
    it 'tracks the week view and distance from the current week', ->
      @analyticsTracker.weekView('03-03-13', 4)
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Weeks', 'Click', '03-03-13', 4]

  describe '#visitDeletion', ->
    it 'tracks visit deletion', ->
      @analyticsTracker.visitDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Visit', 'Delete']

  describe '#groupedVisitDeletion', ->
    it 'tracks grouped visit deletion', ->
      @analyticsTracker.groupedVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Grouped visits', 'Delete']

  describe '#timeIntervalDeletion', ->
    it 'tracks time interval deletion', ->
      @analyticsTracker.timeIntervalDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Time interval', 'Delete']

  describe '#dayVisitsDeletion', ->
    it 'tracks day visits deletion', ->
      @analyticsTracker.dayVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Day visits', 'Delete']

  describe '#weekVisitsDeletion', ->
    it 'tracks week visits deletion', ->
      @analyticsTracker.weekVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Week visits', 'Delete']

  describe '#searchResultsDeletion', ->
    it 'tracks search results deletion', ->
      @analyticsTracker.searchResultsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Search results', 'Delete']

  describe '#paginationClick', ->
    it 'tracks pagination click', ->
      @analyticsTracker.paginationClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Pagination', 'Click'])

  describe '#omniboxSearch', ->
    it 'tracks omnibox searches', ->
      @analyticsTracker.omniboxSearch()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Omnibox', 'Search'])

  describe '#browserActionClick', ->
    it 'tracks browser action click', ->
      @analyticsTracker.browserActionClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Browser action', 'Click'])

  describe '#contextMenuClick', ->
    it 'tracks context menu click', ->
      @analyticsTracker.contextMenuClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Context menu', 'Click'])

  describe '#selectionContextMenuClick', ->
    it 'tracks selection context menu click', ->
      @analyticsTracker.selectionContextMenuClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Selection context menu', 'Click'])

  describe '#syncStorageError', ->
    it 'tracks a storage error', ->
      @analyticsTracker.syncStorageError('get', 'the error')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Storage Error', 'get', 'Sync', 'the error'])

  describe '#syncStorageAccess', ->
    it 'tracks a storage sccess', ->
      @analyticsTracker.syncStorageAccess('get')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Storage Access', 'get', 'Sync'])

  describe '#localStorageError', ->
    it 'tracks a storage error', ->
      @analyticsTracker.localStorageError('get', 'the error')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Storage Error', 'get', 'Local', 'the error'])

  describe '#mailingListPrompt', ->
    it 'tracks the mailing list prompt being seen', ->
      @analyticsTracker.mailingListPrompt()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Mailing List Prompt', 'Seen'])

  describe '#popupVisible', ->
    it 'tracks the popup being seen', ->
      @analyticsTracker.popupVisible()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'Seen'])

  describe '#exploreTagsPopupClick', ->
    it 'tracks the explore tags click in the popup', ->
      @analyticsTracker.exploreTagsPopupClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'Explore Tags Click'])

  describe '#searchByDomainPopupClick', ->
    it 'tracks the search by domain click in the popup', ->
      @analyticsTracker.searchByDomainPopupClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'Search by Domain Click'])

  describe '#viewAllHistoryPopupClick', ->
    it 'tracks the view all history click in the popup', ->
      @analyticsTracker.viewAllHistoryPopupClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'View all History Click'])

  describe '#addTagPopup', ->
    it 'tracks the tagging of a site', ->
      @analyticsTracker.addTagPopup()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'Add Tag'])

  describe '#removeTagPopup', ->
    it 'tracks the removal of a tag from a site', ->
      @analyticsTracker.removeTagPopup()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'Remove Tag'])

  describe '#tagPopupClick', ->
    it 'tracks the click of a tag in the popup', ->
      @analyticsTracker.tagPopupClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'Tag Click'])
