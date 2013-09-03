describe 'BH.Lib.SyncStore', ->
  beforeEach ->
    @callback = jasmine.createSpy("callback")
    @tracker =
      syncStorageError: jasmine.createSpy("syncStorageError")
      syncStorageAccess: jasmine.createSpy("syncStorageAccess")

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

    it 'returns an empty object when no data is provided', ->
      @syncStore.wrappedCallback('get', null, @callback)
      expect(@callback).toHaveBeenCalledWith({})

    it 'does not report any errors', ->
      @syncStore.wrappedCallback('get', 'data', @callback)
      expect(@tracker.syncStorageError).not.toHaveBeenCalled()

    it 'calls to the tracker when the operation is not get', ->
      @syncStore.wrappedCallback('Set', null, @callback)
      expect(@tracker.syncStorageAccess).toHaveBeenCalledWith 'Set'

    it 'does not call to the tracker when the operation is Get', ->
      @syncStore.wrappedCallback('Get', null, @callback)
      expect(@tracker.syncStorageAccess).not.toHaveBeenCalled()
    describe "when as error is detected", ->
      beforeEach ->
        chrome.runtime = lastError: message: 'the error'

      afterEach ->
        delete chrome.runtime.lastError

      it 'calls to the tracker', ->
        @syncStore.wrappedCallback('get', 'data', @callback)
        expect(@tracker.syncStorageError).toHaveBeenCalledWith('get', 'the error')
