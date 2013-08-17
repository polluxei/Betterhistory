BH.Lib.SyncStore =
  set: (object, callback = ->) ->
    chrome.storage.sync.set(object, callback)

  remove: (key, callback = ->) ->
    chrome.storage.sync.remove(key, callback)

  get: (key, callback) ->
    chrome.storage.sync.get(key, callback)

  # Keep localStorage clean. Use Chrome storage
  migrate: (dataSource) ->
    for key,value of dataSource
      data = {}
      data[key] = JSON.parse(dataSource[key])
      @set data
      delete dataSource[key]
    dataSource
