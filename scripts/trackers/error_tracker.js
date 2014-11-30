(function() {
  var ErrorTracker = function(tracker) {
    this.tracker = tracker;
    this.tracker.setContext({version: BH.config.version});
    this.tracker.configure({
      api_key: BH.config.errorsKey,
      environment: BH.config.env,
      onerror: true
    });
  };

  ErrorTracker.prototype.report = function(e, data) {
      this.tracker.notify(e, {context: data});
  };

  BH.Trackers.ErrorTracker = ErrorTracker;
})();
