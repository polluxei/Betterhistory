describe 'BH.Init.TagFeature', ->
  beforeEach ->
    @callback = jasmine.createSpy('callback')

    syncStore = get: jasmine.createSpy('get')

    @tagFeature = new BH.Init.TagFeature
      syncStore: syncStore

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
    describe 'when tag instructions have not been dismissed and no tags have been created', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) ->
          callback({})
        persistence.tag().fetchTags.andCallFake (callback) ->
          callback([])

      it 'calls the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).toHaveBeenCalled()

    describe 'when tag instructions have been dismissed and no tags have been created', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) ->
          callback(tagInstructionsDismissed: true)
        persistence.tag().fetchTags.andCallFake (callback) ->
          callback([])

      it 'does not call the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).not.toHaveBeenCalled()

    describe 'when tag instructions have not been dismissed and tags have been created', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) ->
          callback({})
        persistence.tag().fetchTags.andCallFake (callback) ->
          callback(['cars'])

      it 'does not call the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).not. toHaveBeenCalled()

    describe 'when tag instructions have been dismissed and tags have been created', ->
      beforeEach ->
        @tagFeature.syncStore.get.andCallFake (key, callback) ->
          callback(tagInstructionsDismissed: true)
        persistence.tag().fetchTags.andCallFake (callback) ->
          callback(['cars'])

      it 'does not call the callback', ->
        @tagFeature.prepopulate(@callback)
        expect(@callback).not.toHaveBeenCalled()
