describe 'BH.Lib.ExampleTags', ->
  beforeEach ->
    persistence =
      fetchTags: jasmine.createSpy('fetchTags')
    localStore =
      set: jasmine.createSpy('set').andCallFake (data, callback) ->
        callback()

    @exampleTags = new BH.Lib.ExampleTags
      persistence: persistence
      localStore: localStore

  describe '#load', ->
    it 'calls set on localStore with the example tags', ->
      @exampleTags.load()
      expect(@exampleTags.localStore.set).toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function)

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @exampleTags.load(callback)
      expect(callback).toHaveBeenCalled()
