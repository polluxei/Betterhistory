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

  describe '#tagDetailsPopupClick', ->
    it 'tracks a click on tag details', ->
      @analyticsTracker.tagDetailsPopupClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popip', 'Tag Details Click'])

  describe '#viewAllHistoryPopupClick', ->
    it 'tracks the view all history click in the popup', ->
      @analyticsTracker.viewAllHistoryPopupClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Popup', 'View all History Click'])

  describe '#howToTagClick', ->
    it 'tracks the click of how to tag link', ->
      @analyticsTracker.howToTagClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tags', 'How to Tag Click'])

  describe '#deleteAllTagsClick', ->
    it 'tracks the deleting of all tags', ->
      @analyticsTracker.deleteAllTagsClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tags', 'Delete all Click'])

  describe '#siteTagDrag', ->
    it 'tracks the drag of a site', ->
      @analyticsTracker.siteTagDrag()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tag', 'Site Drag'])

  describe '#siteTagDrop', ->
    it 'tracks the drop of a site', ->
      @analyticsTracker.siteTagDrop()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tag', 'Site Drop'])

  describe '#renameTagClick', ->
    it 'tracks the rename tag click', ->
      @analyticsTracker.renameTagClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tag', 'Rename Click'])

  describe '#deleteTagClick', ->
    it 'tracks the deleting of a tag', ->
      @analyticsTracker.deleteTagClick()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tag', 'Delete Tag Click'])

  describe '#tagAdded', ->
    it 'tracks a tag added', ->
      @analyticsTracker.tagAdded()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tag', 'Added'])

  describe '#tagRemoved', ->
    it 'tracks a tag removed', ->
      @analyticsTracker.tagRemoved()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tag', 'Removed'])

  describe '#tagRenamed', ->
    it 'tracks a tag renamed', ->
      @analyticsTracker.tagRenamed()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Tag', 'Renamed'])

  describe '#siteTagged', ->
    it 'tracks a site tagged', ->
      @analyticsTracker.siteTagged()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Site', 'Tagged'])

  describe '#siteUntagged', ->
    it 'tracks a site untagged', ->
      @analyticsTracker.siteUntagged()
      expect(@analytics.push).toHaveBeenCalledWith(['_trackEvent', 'Site', 'Untagged'])
