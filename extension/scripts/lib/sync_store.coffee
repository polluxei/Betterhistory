class BH.Lib.SyncStore
  constructor: (options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "Tracker not set" unless options.tracker?

    @chromeAPI = options.chrome
    @tracker = options.tracker

  set: (object, callback = ->) ->
    @chromeAPI.storage.sync.set object, (data) =>
      @wrappedCallback('Set', data, callback)

  remove: (key, callback = ->) ->
    @chromeAPI.storage.sync.remove key, (data) =>
      @wrappedCallback('Remove', data, callback)

  get: (key, callback) ->
    @chromeAPI.storage.sync.get key, (data) =>
      @wrappedCallback('Get', data, callback)

  wrappedCallback: (operation, data = {}, callback) ->
    if @chromeAPI.runtime.lastError?
      message = @chromeAPI.runtime.lastError?.message
      @tracker.syncStorageError(operation, message)
    else
      # Don't track Get access because it happens a lot
      @tracker.syncStorageAccess(operation) if operation != 'Get'
    callback(data)
