describe 'BH.Collections.Tags', ->
  beforeEach ->
    localStore =
      get: jasmine.createSpy('get')
      set: jasmine.createSpy('set')
      remove: jasmine.createSpy('remove')

    @tags = new BH.Collections.Tags {},
      chrome: chrome
      localStore: localStore

  describe '#fetch', ->
    describe 'when no tags exist', ->
      beforeEach ->
        @tags.localStore.get.andCallFake (key, callback) =>
          callback {}

      it 'resets the collection to an empty models arrays', ->
        @tags.on 'reset', =>
          expect(@tags.models.length).toEqual 0
        @tags.fetch()

    describe 'when tags exist', ->
      beforeEach ->
        @tags.localStore.get.andCallFake (key, callback) =>
          if key == 'tags'
            callback
              tags: ['recipes', 'cooking']
          else if _.isEqual(key, ['recipes', 'cooking'])
            callback
              'recipes': [{
                title: 'Pound Cake'
                url: 'http://www.recipes.com/pound_cake'
                datetime: new Date('2/3/12').getTime()
              }, {
                title: 'Angel Food Cake'
                url: 'http://www.recipes.com/food'
                datetime: new Date('4/2/13').getTime()
              }],
              'cooking': [{
                title: 'Pan Frying'
                url: 'http://www.atk.com/pan_frying'
                datetime: new Date('2/2/12').getTime()
              }, {
                title: 'Baking'
                url: 'http://www.recipes.com/pound_cake'
                datetime: new Date('4/3/12').getTime()
              }]

      it 'resets the collection to the found tags and sites', ->
        @tags.on 'reset', =>
          expect(@tags.toJSON()).toEqual [{
            name: 'recipes'
            sites: [{
              title: 'Pound Cake'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('2/3/12').getTime()
            }, {
              title: 'Angel Food Cake'
              url: 'http://www.recipes.com/food'
              datetime: new Date('4/2/13').getTime()
            }],
          }, {
            name: 'cooking'
            sites: [{
              title: 'Pan Frying'
              url: 'http://www.atk.com/pan_frying'
              datetime: new Date('2/2/12').getTime()
            }, {
              title: 'Baking'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('4/3/12').getTime()
            }]
          }]

        @tags.fetch()

  describe '#destroy', ->
    beforeEach ->
      @tags.localStore.get.andCallFake (key, callback) =>
        if key == 'tags'
          callback tags: ['recipes', 'cooking']

    it 'removes all the tag data and the keys key', ->
      @tags.destroy()
      expect(@tags.localStore.remove).toHaveBeenCalledWith ['recipes', 'cooking', 'tags']
