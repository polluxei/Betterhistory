describe 'BH.Init.Persistence', ->
  beforeEach ->
    @persistence = new BH.Init.Persistence
      localStore: {}
      ajax: {}
      state: {}

  describe '#tag', ->
    it 'returns a Tag Persistence instance', ->
      expect(@persistence.tag().constructor.name).toEqual("Tag")

  describe '#remote', ->
    it 'returns a Remote Persistence instance', ->
      expect(@persistence.remote().constructor.name).toEqual('Remote')
