describe 'BH.Lib.SyncStore', ->
  beforeEach ->
    @callback = jasmine.createSpy("callback")
    @tracker =
      syncStorageError: jasmine.createSpy("syncStorageError")

    @syncStore = new BH.Lib.SyncStore
      chrome: chrome
      tracker: @tracker

  describe '#set', ->
    beforeEach ->
      @object = data: 'yes, data'

    it 'calls to the storage api to set the object', ->
      @syncStore.set(@object)
      expect(chrome.storage.sync.set).toHaveBeenCalledWith(@object, jasmine.any(Function))

    it 'passes a callback through when passed', ->
      @syncStore.set(@object, jasmine.any(Function))
      expect(chrome.storage.sync.set).toHaveBeenCalledWith(@object, jasmine.any(Function))

  describe '#remove', ->
    it 'calls to the storage api to remove the object', ->
      @syncStore.remove('key')
      expect(chrome.storage.sync.remove).toHaveBeenCalledWith('key', jasmine.any(Function))

    it 'passes a callback through when passed', ->
      @syncStore.remove('key', jasmine.any(Function))
      expect(chrome.storage.sync.remove).toHaveBeenCalledWith('key', jasmine.any(Function))

  describe '#get', ->
    it 'calls to the storage api to get the object', ->
      @syncStore.get('key', jasmine.any(Function))
      expect(chrome.storage.sync.get).toHaveBeenCalledWith('key', jasmine.any(Function))

  describe '#wrappedCallback', ->
    it 'calls the passed callback with the passed data', ->
      @syncStore.wrappedCallback('get', 'data', @callback)
      expect(@callback).toHaveBeenCalledWith('data')

    it 'does not report any errors', ->
      @syncStore.wrappedCallback('get', 'data', @callback)
      expect(@tracker.syncStorageError).not.toHaveBeenCalled()

    describe "when as error is detected", ->
      beforeEach ->
        chrome.runtime = lastError: message: 'the error'

      afterEach ->
        delete chrome.runtime.lastError

      it 'calls to the tracker', ->
        @syncStore.wrappedCallback('get', 'data', @callback)
        expect(@tracker.syncStorageError).toHaveBeenCalledWith('get', 'the error')

  describe '#migrate', ->
    beforeEach ->
      @dataSource =
        mailingListPromptTimer: '2'
        state: "{\"route\":\"#weeks/8-12-13\"}"

    it 'calls the chrome api to set the data for each key in the data source', ->
      @syncStore.migrate(@dataSource)
      expect(chrome.storage.sync.set).toHaveBeenCalledWith({mailingListPromptTimer: 2}, jasmine.any(Function))
      expect(chrome.storage.sync.set).toHaveBeenCalledWith({state: {route: "#weeks/8-12-13"}}, jasmine.any(Function))

    it 'deletes the keys and data on the passed data source', ->
      modifiedSource = @syncStore.migrate(@dataSource)
      expect(modifiedSource.mailingListPromptTimer).toBeUndefined()
      expect(modifiedSource.state).toBeUndefined()

