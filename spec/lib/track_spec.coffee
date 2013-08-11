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
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Weeks', 'Clicked', '03-03-13', 4]

  describe '#visitDeletion', ->
    it 'tracks visit deletion', ->
      @track.visitDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Delete', 'Clicked', 'visit']

  describe '#groupedVisitDeletion', ->
    it 'tracks grouped visit deletion', ->
      @track.groupedVisitDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Delete', 'Clicked', 'grouped visit']

  describe '#timeIntervalDeletion', ->
    it 'tracks time interval deletion', ->
      @track.timeIntervalDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Delete', 'Clicked', 'time interval']

  describe '#dayVisitsDeletion', ->
    it 'tracks day visits deletion', ->
      @track.dayVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Delete', 'Clicked', 'day visits']

  describe '#weekVisitsDeletion', ->
    it 'tracks week visits deletion', ->
      @track.weekVisitsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Delete', 'Clicked', 'week visits']

  describe '#searchResultsDeletion', ->
    it 'tracks search results deletion', ->
      @track.searchResultsDeletion()
      expect(@analytics.push).toHaveBeenCalledWith ['_trackEvent', 'Delete', 'Clicked', 'search results']
