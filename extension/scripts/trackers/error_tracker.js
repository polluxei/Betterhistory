(function() {
  var key = "$ERROR_TRACKER_ID$",
      version = "$VERSION$",
      environment = "$ENVIRONMENT$";

  var ErrorTracker = function(tracker) {
    this.tracker = tracker;
    this.tracker.setContext({version: version});
    this.tracker.configure({
      api_key: key,
      environment: environment,
      onerror: true
    });
  };

  ErrorTracker.prototype.report = function(e, data) {
      this.tracker.notify(e, {context: data});
  };

  BH.Trackers.ErrorTracker = ErrorTracker;
})();
