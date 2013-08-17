describe 'BH.Lib.SyncStore', ->
  beforeEach ->
    @callback = jasmine.createSpy("callback")

  describe '.set', ->
    beforeEach ->
      @object = data: 'yes, data'

    it 'calls to the storage api to set the object', ->
      BH.Lib.SyncStore.set(@object)
      expect(chrome.storage.sync.set).toHaveBeenCalledWith(@object, jasmine.any(Function))

    it 'passes a callback through when passed', ->
      BH.Lib.SyncStore.set(@object, @callback)
      expect(chrome.storage.sync.set).toHaveBeenCalledWith(@object, @callback)

  describe '.remove', ->
    it 'calls to the storage api to remove the object', ->
      BH.Lib.SyncStore.remove('key')
      expect(chrome.storage.sync.remove).toHaveBeenCalledWith('key', jasmine.any(Function))

    it 'passes a callback through when passed', ->
      BH.Lib.SyncStore.remove('key', @callback)
      expect(chrome.storage.sync.remove).toHaveBeenCalledWith('key', @callback)

  describe '.get', ->
    it 'calls to the storage api to get the object', ->
      BH.Lib.SyncStore.get('key', @callback)
      expect(chrome.storage.sync.get).toHaveBeenCalledWith('key', @callback)

  describe '.migrate', ->
    beforeEach ->
      @dataSource =
        mailingListPromptTimer: '2'
        state: "{\"route\":\"#weeks/8-12-13\"}"

    it 'calls the chrome api to set the data for each key in the data source', ->
      BH.Lib.SyncStore.migrate(@dataSource)
      expect(chrome.storage.sync.set).toHaveBeenCalledWith({mailingListPromptTimer: 2}, jasmine.any(Function))
      expect(chrome.storage.sync.set).toHaveBeenCalledWith({state: {route: "#weeks/8-12-13"}}, jasmine.any(Function))

    it 'deletes the keys and data on the passed data source', ->
      modifiedSource = BH.Lib.SyncStore.migrate(@dataSource)
      expect(modifiedSource.mailingListPromptTimer).toBeUndefined()
      expect(modifiedSource.state).toBeUndefined()


