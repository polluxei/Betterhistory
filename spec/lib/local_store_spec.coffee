describe 'BH.Lib.LocalStore', ->
  beforeEach ->
    @callback = jasmine.createSpy("callback")
    @tracker =
      localStorageError: jasmine.createSpy("localStorageError")

    @localStore = new BH.Lib.LocalStore
      chrome: chrome
      tracker: @tracker

  describe '#set', ->
    beforeEach ->
      @object = data: 'yes, data'

    it 'calls to the storage api to set the object', ->
      @localStore.set(@object)
      expect(chrome.storage.local.set).toHaveBeenCalledWith(@object, jasmine.any(Function))

    it 'passes a callback through when passed', ->
      @localStore.set(@object, jasmine.any(Function))
      expect(chrome.storage.local.set).toHaveBeenCalledWith(@object, jasmine.any(Function))

  describe '#remove', ->
    it 'calls to the storage api to remove the object', ->
      @localStore.remove('key')
      expect(chrome.storage.local.remove).toHaveBeenCalledWith('key', jasmine.any(Function))

    it 'passes a callback through when passed', ->
      @localStore.remove('key', jasmine.any(Function))
      expect(chrome.storage.local.remove).toHaveBeenCalledWith('key', jasmine.any(Function))

  describe '#get', ->
    it 'calls to the storage api to get the object', ->
      @localStore.get('key', jasmine.any(Function))
      expect(chrome.storage.local.get).toHaveBeenCalledWith('key', jasmine.any(Function))

  describe '#wrappedCallback', ->
    it 'calls the passed callback with the passed data', ->
      @localStore.wrappedCallback('get', 'data', @callback)
      expect(@callback).toHaveBeenCalledWith('data')

    it 'does not report any errors', ->
      @localStore.wrappedCallback('get', 'data', @callback)
      expect(@tracker.localStorageError).not.toHaveBeenCalled()

    describe "when as error is detected", ->
      beforeEach ->
        chrome.runtime = lastError: message: 'the error'

      afterEach ->
        delete chrome.runtime.lastError

      it 'calls to the tracker', ->
        @localStore.wrappedCallback('get', 'data', @callback)
        expect(@tracker.localStorageError).toHaveBeenCalledWith('get', 'the error')
