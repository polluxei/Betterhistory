describe 'BH.Trackers.ErrorTracker', ->
  beforeEach ->
    tracker = configure: jasmine.createSpy('configure')
    @errorTracker = new BH.Trackers.ErrorTracker(tracker)

  describe '#constructor', ->
    it 'configures the tracker', ->
      expect(@errorTracker.tracker.configure).toHaveBeenCalledWith
        api_key: '$ERROR_TRACKER_ID$'
        onerror: true
