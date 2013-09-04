describe 'BH.Models.Tag', ->
  beforeEach ->
    localStore =
      get: jasmine.createSpy('get')
      set: jasmine.createSpy('set')
      remove: jasmine.createSpy('remove')

    @tag = new BH.Models.Tag name: 'recipes',
      chrome: chrome
      localStore: localStore

  describe '#fetch', ->
    describe 'when no tag exist', ->
      beforeEach ->
        @tag.localStore.get.andCallFake (key, callback) =>
          callback {}

      it 'sets the sites to an empty array', ->
        @tag.on 'reset', =>
          expect(@tag.get('sites').length).toEqual 0
        @tag.fetch()

    describe 'when tags exist', ->
      beforeEach ->
        @tag.localStore.get.andCallFake (key, callback) =>
          callback
            'recipes': [{
              title: 'Pound Cake'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('2/3/12').getTime()
            }, {
              title: 'Angel Food Cake'
              url: 'http://www.recipes.com/food'
              datetime: new Date('4/2/13').getTime()
            }]

      it 'sets the sites', ->
        @tag.on 'change:sites', =>
          expect(@tag.toJSON()).toEqual
            name: 'recipes'
            sites: [{
              title: 'Pound Cake'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('2/3/12').getTime()
            }, {
              title: 'Angel Food Cake'
              url: 'http://www.recipes.com/food'
              datetime: new Date('4/2/13').getTime()
            }]

        @tag.fetch()

  describe '#destroy', ->
    beforeEach ->
      @tag.localStore.get.andCallFake (key, callback) =>
        if key == 'tags'
          callback tags: ['recipes', 'cooking']
      @tag.localStore.set.andCallFake (key, callback) =>
        callback()
      @tag.localStore.remove.andCallFake (key, callback) =>
        callback()

    it 'removes the tag from the tags key', ->
      @tag.destroy()
      expect(@tag.localStore.set).toHaveBeenCalledWith {tags: ['cooking']}, jasmine.any(Function)

    it 'removes the tag data', ->
      @tag.destroy()
      expect(@tag.localStore.remove).toHaveBeenCalledWith 'recipes', jasmine.any(Function)

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @tag.destroy(callback)
      expect(callback).toHaveBeenCalled()

  describe '#removeSite', ->
    beforeEach ->
      @tag.localStore.get.andCallFake (key, callback) ->
        callback
          recipes: [{
            title: 'Pound Cake'
            url: 'http://www.recipes.com/pound_cake'
            datetime: new Date('2/3/12').getTime()
          }, {
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }]
      @tag.localStore.set.andCallFake (key, callback) =>
        callback()

    it 'removes the site from the tag in localStore', ->
      @tag.removeSite('http://www.recipes.com/pound_cake')
      expect(@tag.localStore.set).toHaveBeenCalledWith
        recipes: [{
          title: 'Angel Food Cake'
          url: 'http://www.recipes.com/food'
          datetime: new Date('4/2/13').getTime()
        }]
      , jasmine.any(Function)

    it 'updates the sites attribute', ->
      @tag.removeSite 'http://www.recipes.com/pound_cake', =>
        expect(@tag.get('sites')).toEqual [{
          title: 'Angel Food Cake'
          url: 'http://www.recipes.com/food'
          datetime: new Date('4/2/13').getTime()
        }]

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @tag.removeSite('http://www.recipes.com/pound_cake', callback)
      expect(callback).toHaveBeenCalled()

