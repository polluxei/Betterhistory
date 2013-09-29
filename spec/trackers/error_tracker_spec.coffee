describe 'BH.Trackers.ErrorTracker', ->
  beforeEach ->
    tracker =
      configure: jasmine.createSpy('configure')
      notify: jasmine.createSpy('notify')
      setContext: jasmine.createSpy('setContext')
    @errorTracker = new BH.Trackers.ErrorTracker(tracker)

  describe '#constructor', ->
    it 'configures the tracker', ->
      expect(@errorTracker.tracker.configure).toHaveBeenCalledWith
        api_key: '$ERROR_TRACKER_ID$'
        environment: '$ENVIRONMENT$'
        onerror: true

    it 'sets the version on the context', ->
      expect(@errorTracker.tracker.setContext).toHaveBeenCalledWith
        version: '$VERSION$'

  describe '#report', ->
    it 'calls to the tracker with the error', ->
      @errorTracker.report('error', {data: 'true'})
      expect(@errorTracker.tracker.notify).toHaveBeenCalledWith('error', context: {data: 'true'})
