describe 'BH.Lib.ExampleTags', ->
  beforeEach ->
    global.user =
      isLoggedIn: jasmine.createSpy('isLoggedIn').andReturn false
    localStore =
      set: jasmine.createSpy('set').andCallFake (data, callback) ->
        callback()

    @exampleTags = new BH.Lib.ExampleTags
      localStore: localStore
    @exampleTags.syncPersistence =
      updateSites: jasmine.createSpy('updateSites')

  describe '#load', ->
    it 'calls set on localStore with the example tags', ->
      @exampleTags.load()
      expect(@exampleTags.localStore.set).toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function)

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @exampleTags.load(callback)
      expect(callback).toHaveBeenCalled()

    it 'does not sync the changes', ->
      @exampleTags.load()
      expect(@exampleTags.syncPersistence.updateSites).not.toHaveBeenCalled()

    describe 'when user is logged in', ->
      beforeEach ->
        global.user.isLoggedIn.andReturn true

      it 'persists the example tags', ->
        @exampleTags.load()
        expect(@exampleTags.syncPersistence.updateSites.mostRecentCall.args[0].length).toEqual 61
