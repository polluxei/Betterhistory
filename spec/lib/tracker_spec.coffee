describe 'BH.Lib.Tracker', ->
  beforeEach ->
    @page = {}
    @analytics = push: jasmine.createSpy('push')
    @tracker = new BH.Lib.Tracker(@analytics, @page)

  describe '#constructor', ->
    it 'listens for errors on the page', ->
      expect(@page.onerror).toBeDefined()

  describe '#pageView', ->
    it 'tracks the current url fragment', ->
      @tracker.pageView('page/url')
      expect(@analytics.push).toHaveBeenCalledWith ['_trackPageview', '/page/url']

    it 'does not track the search term in a url', ->
      @tracker.pageView('search/term')
      expect(@analytics.push).toHaveBeenCalledWith ['_trackPageview', '/search']

  describe '#weekView', ->
    it 'tracks the week view and distance from the current week', ->
      @tracker.weekView('03-03-13', 4)
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Weeks', 'Click', '03-03-13', 4]

  describe '#visitDeletion', ->
    it 'tracks visit deletion', ->
      @tracker.visitDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Visit', 'Delete']

  describe '#groupedVisitDeletion', ->
    it 'tracks grouped visit deletion', ->
      @tracker.groupedVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Grouped visits', 'Delete']

  describe '#timeIntervalDeletion', ->
    it 'tracks time interval deletion', ->
      @tracker.timeIntervalDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Time interval', 'Delete']

  describe '#dayVisitsDeletion', ->
    it 'tracks day visits deletion', ->
      @tracker.dayVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Day visits', 'Delete']

  describe '#weekVisitsDeletion', ->
    it 'tracks week visits deletion', ->
      @tracker.weekVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Week visits', 'Delete']

  describe '#searchResultsDeletion', ->
    it 'tracks search results deletion', ->
      @tracker.searchResultsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Search results', 'Delete']

  describe '#paginationClick', ->
    it 'tracks pagination click', ->
      @tracker.paginationClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Pagination', 'Click'])

  describe '#omniboxSearch', ->
    it 'tracks omnibox searches', ->
      @tracker.omniboxSearch()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Omnibox', 'Search'])

  describe '#browserActionClick', ->
    it 'tracks browser action click', ->
      @tracker.browserActionClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Browser action', 'Click'])

  describe '#contextMenuClick', ->
    it 'tracks context menu click', ->
      @tracker.contextMenuClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Context menu', 'Click'])

  describe '#selectionContextMenuClick', ->
    it 'tracks selection context menu click', ->
      @tracker.selectionContextMenuClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Selection context menu', 'Click'])

  describe '#syncStorageError', ->
    it 'tracks a storage error', ->
      @tracker.syncStorageError('get', 'the error')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Storage Error', 'get', 'Sync', 'the error'])

  describe '#syncStorageAccess', ->
    it 'tracks a storage sccess', ->
      @tracker.syncStorageAccess('get')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Storage Access', 'get', 'Sync'])

  describe '#mailingListPrompt', ->
    it 'tracks the mailing list prompt being seen', ->
      @tracker.mailingListPrompt()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Mailing List Prompt', 'Seen'])

  describe '#error', ->
    it 'tracks an error', ->
      @tracker.error('message', 'url', 'line number')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Error', 'message', 'url', 'line number'])
