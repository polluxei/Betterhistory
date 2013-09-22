describe 'BH.Init.TagFeature', ->
  beforeEach ->
    @callback = jasmine.createSpy('callback')

    syncStore = get: jasmine.createSpy('get')
    localStore = get: jasmine.createSpy('get')

    @tagFeature = new BH.Init.TagFeature
      syncStore: syncStore
      localStore: localStore

  describe '#announce', ->
    it 'calls callback when tag instructions have not been dismissed', ->
      @tagFeature.syncStore.get.andCallFake (key, callback) -> callback({})
      @tagFeature.announce(@callback)
      expect(@callback).toHaveBeenCalled()

    it 'does not call the callback when tag instructions have been dismissed', ->
      @tagFeature.syncStore.get.andCallFake (key, callback) -> callback(tagInstructionsDismissed: true)
      @tagFeature.announce(@callback)
      expect(@callback).not.toHaveBeenCalled()

  describe '#prepopulate', ->
    describe 'when tag instructions have not been dismissed and the tags key does not exist in the localStore', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) -> callback({})
        @tagFeature.localStore.get.andCallFake (key, callback) -> callback({})

      it 'calls the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).toHaveBeenCalled()

    describe 'when tag instructions have been dismissed and the tags key does not exist in the localStore', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) ->
          callback(tagInstructionsDismissed: true)
        @tagFeature.localStore.get.andCallFake (key, callback) -> callback({})

      it 'does not call the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).not.toHaveBeenCalled()

    describe 'when tag instructions have not been dismissed and the tags key does exist in the localStore', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) -> callback({})
        @tagFeature.localStore.get.andCallFake (key, callback) -> callback(tags: [])

      it 'does not call the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).not. toHaveBeenCalled()

    describe 'when tag instructions have been dismissed and the tags key does exist in the localStore', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) ->
          callback(tagInstructionsDismissed: true)
        @tagFeature.localStore.get.andCallFake (key, callback) ->
          callback(tags: [])

      it 'does not call the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).not. toHaveBeenCalled()
