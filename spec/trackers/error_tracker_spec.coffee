describe 'BH.Trackers.ErrorTracker', ->
  beforeEach ->
    tracker =
      configure: jasmine.createSpy('configure')
      notify: jasmine.createSpy('notify')
    @errorTracker = new BH.Trackers.ErrorTracker(tracker)

  describe '#constructor', ->
    it 'configures the tracker', ->
      expect(@errorTracker.tracker.configure).toHaveBeenCalledWith
        api_key: '$ERROR_TRACKER_ID$'
        environment: '$ENVIRONMENT$'
        onerror: true

  describe '#report', ->
    it 'calls to the tracker with the error', ->
      @errorTracker.report('error')
      expect(@errorTracker.tracker.notify).toHaveBeenCalledWith('error', context: {version: '$VERSION$'})
