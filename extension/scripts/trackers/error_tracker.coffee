class BH.Trackers.ErrorTracker
  key: "$ERROR_TRACKER_ID$"
  version: "$VERSION$"
  environment: "$ENVIRONMENT$"

  constructor: (tracker) ->
    @tracker = tracker
    @tracker.configure
      api_key: @key
      environment: @environment
      onerror: true

  report: (e, data = {}) ->
    data.version = @version
    @tracker.notify e, context: data
