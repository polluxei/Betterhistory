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
      @tracker.localStorageError('get', 'the error')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Storage Error', 'get', 'Local', 'the error'])

  describe '#mailingListPrompt', ->
    it 'tracks the mailing list prompt being seen', ->
      @analyticsTracker.mailingListPrompt()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Mailing List Prompt', 'Seen'])
