(function() {

  var chromeAPI, tracker = null;

  wrappedCallback = function(operation, data, callback) {
    if(chromeAPI.runtime.lastError) {
      var message = chromeAPI.runtime.lastError.message;
      tracker.syncStorageError(operation, message);
    } else {
      // Don't track Get access because it happens a lot
      if(operation !== 'Get') {
        tracker.syncStorageAccess(operation);
      }
    }
    callback(data);
  };

  var SyncStore = function(options) {
    chromeAPI = options.chrome;
    tracker = options.tracker;
  };

  SyncStore.prototype.set = function(object, callback) {
    chromeAPI.storage.sync.set(object, function(data) {
      wrappedCallback('Set', data, callback);
    });
  };

  SyncStore.prototype.remove = function(key, callback) {
    chromeAPI.storage.sync.remove(key, function(data) {
      wrappedCallback('Remove', data, callback);
    });
  };

  SyncStore.prototype.get = function(key, callback) {
    chromeAPI.storage.sync.get(key, function(data) {
      wrappedCallback('Get', data, callback);
    });
  };

  BH.Chrome.SyncStore = SyncStore;
})();
