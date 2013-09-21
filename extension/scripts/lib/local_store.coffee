class BH.Lib.LocalStore
  constructor: (options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "Tracker not set" unless options.tracker?

    @chromeAPI = options.chrome
    @tracker = options.tracker

  set: (object, callback = ->) ->
    @chromeAPI.storage.local.set object, (data) =>
      @wrappedCallback('Set', data, callback)

  remove: (key, callback = ->) ->
    @chromeAPI.storage.local.remove key, (data) =>
      @wrappedCallback('Remove', data, callback)

  get: (key, callback) ->
    @chromeAPI.storage.local.get key, (data) =>
      @wrappedCallback('Get', data, callback)

  wrappedCallback: (operation, data, callback) ->
    if @chromeAPI.runtime.lastError?
      message = @chromeAPI.runtime.lastError?.message
      @tracker.localStorageError(operation, message)
    callback(data)
