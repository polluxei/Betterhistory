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

  wrappedCallback: (operation, data, callback) ->
    if @chromeAPI.runtime.lastError?
      message = @chromeAPI.runtime.lastError?.message
      @tracker.syncStorageError(operation, message)
    callback(data)

  # Keep localStorage clean. Use Chrome storage
  migrate: (dataSource) ->
    for key,value of dataSource
      data = {}
      data[key] = JSON.parse(dataSource[key])
      @set data
      delete dataSource[key]
    dataSource
