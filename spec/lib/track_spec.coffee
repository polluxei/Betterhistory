describe 'BH.Lib.Track', ->
  beforeEach ->
    @analytics = push: jasmine.createSpy('push')
    @track = new BH.Lib.Track(@analytics)

  describe '#pageView', ->
    it 'tracks the current url fragment', ->
      @track.pageView('page/url')
      expect(@analytics.push).toHaveBeenCalledWith ['_trackPageview', '/page/url']

    it 'does not track the search term in a url', ->
      @track.pageView('search/term')
      expect(@analytics.push).toHaveBeenCalledWith ['_trackPageview', '/search']

  describe '#weekView', ->
    it 'tracks the week view and distance from the current week', ->
      @track.weekView('03-03-13', 4)
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Weeks', 'Click', '03-03-13', 4]

  describe '#visitDeletion', ->
    it 'tracks visit deletion', ->
      @track.visitDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Visit', 'Delete']

  describe '#groupedVisitDeletion', ->
    it 'tracks grouped visit deletion', ->
      @track.groupedVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Grouped visits', 'Delete']

  describe '#timeIntervalDeletion', ->
    it 'tracks time interval deletion', ->
      @track.timeIntervalDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Time interval', 'Delete']

  describe '#dayVisitsDeletion', ->
    it 'tracks day visits deletion', ->
      @track.dayVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Day visits', 'Delete']

  describe '#weekVisitsDeletion', ->
    it 'tracks week visits deletion', ->
      @track.weekVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Week visits', 'Delete']

  describe '#searchResultsDeletion', ->
    it 'tracks search results deletion', ->
      @track.searchResultsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Search results', 'Delete']

  describe '#paginationClick', ->
    it 'tracks pagination click', ->
      @track.paginationClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Pagination', 'Click'])

  describe '#omniboxSearch', ->
    it 'tracks omnibox searches', ->
      @track.omniboxSearch()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Omnibox', 'Search'])

  describe '#browserActionClick', ->
    it 'tracks browser action click', ->
      @track.browserActionClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Browser action', 'Click'])

  describe '#contextMenuClick', ->
    it 'tracks context menu click', ->
      @track.contextMenuClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Context menu', 'Click'])

  describe '#selectionContextMenuClick', ->
    it 'tracks selection context menu click', ->
      @track.selectionContextMenuClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Selection context menu', 'Click'])

  describe '#syncStorageError', ->
    it 'tracks a storage error', ->
      @track.syncStorageError('get', 'the error')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Storage Error', 'get', 'Sync', 'the error'])

  describe '#error', ->
    it 'tracks an error', ->
      @track.error('message', 'url', 'line number')
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Error', 'message', 'url', 'line number'])
