(function() {
  var ErrorTracker = function(tracker) {
    this.tracker = tracker;
    if(BH.config.version) {
      this.tracker.setContext({version: BH.config.version});
    }
    this.tracker.configure({
      api_key: BH.config.errorKey,
      environment: BH.config.env,
      onerror: true
    });
  };

  ErrorTracker.prototype.report = function(e, data) {
      this.tracker.notify(e, {context: data});
  };

  BH.Lib.ErrorTracker = ErrorTracker;
})();
