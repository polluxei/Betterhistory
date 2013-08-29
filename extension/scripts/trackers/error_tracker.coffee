class BH.Trackers.ErrorTracker
  key: "$ERROR_TRACKER_ID$"

  constructor: (tracker) ->
    @tracker = tracker
    @tracker.configure
      api_key: @key
      onerror: true

