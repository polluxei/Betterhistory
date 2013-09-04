describe 'BH.Models.Site', ->
  beforeEach ->
    localStore =
      get: jasmine.createSpy('get')
      set: jasmine.createSpy('set')

    @site = new BH.Models.Site {},
      chrome: chrome
      localStore: localStore

  describe '#fetch', ->
    beforeEach ->
      tabs = [{
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipe'
      }]
      chrome.tabs.query.andCallFake (options, callback) ->
        callback(tabs)
      @site.localStore.get.andCallFake (key, callback) ->
        if key == 'tags'
          callback tags: ['recipes', 'cooking']
        else if _.isEqual(key, ['recipes', 'cooking'])
          callback
            'recipes': [
              {url: 'http://www.recipes.com/pound_cake'}
              {url: 'http://www.goodhousekeeping.com/food'}
            ],
            'cooking': [
              {url: 'http://www.atk.com/recent'}
              {url: 'http://www.recipes.com/pound_cake'}
            ]

    it 'sets the site attributes and collects it\'s tags', ->
      @site.fetch()
      expect(@site.toJSON()).toEqual
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipe'
        domain: 'recipes.com'
        tags: ['recipes', 'cooking']

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @site.fetch(callback)
      expect(callback).toHaveBeenCalled()

    describe 'when no tags exist', ->
      beforeEach ->
        @site.localStore.get.andCallFake (key, callback) ->
          callback {}

      it 'sets the site attributes', ->
        @site.fetch()
        expect(@site.toJSON()).toEqual
          url: 'http://www.recipes.com/pound_cake'
          title: 'Pound cake recipe'
          domain: 'recipes.com'
          tags: []

  describe '#addTag', ->
    beforeEach ->
      @site.set
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipes'
        tags: ['cooking']

    it 'returns false if the tag is found in the tags', ->
      expect(@site.addTag('cooking')).toEqual false

    it 'returns false if the tag is empty', ->
      expect(@site.addTag('   ')).toEqual false

    describe 'when the tag is valid', ->
      beforeEach ->
        @site.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking']

      it 'adds the passed tag to the tags attribute', ->
        @site.on 'change:tags', =>
          tags = ['cooking', 'recipes']
          expect(@site.get('tags')).toEqual tags
        @site.addTag('recipes')

      it 'adds the tag to the tags array in localStore', ->
        @site.addTag('recipes')
        expect(@site.localStore.set).toHaveBeenCalledWith
          'tags': ['cooking', 'recipes']

    describe 'when the tag is brand new', ->
      beforeEach ->
        timekeeper.freeze(new Date('10-23-12'))
        @site.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking']
          else if key == 'recipes'
            callback {}

      it 'creates the tag with the site in localStore', ->
        @site.addTag('recipes')
        expect(@site.localStore.set).toHaveBeenCalledWith
          'recipes': [
            {
              title: 'Pound cake recipes'
              url: 'http://www.recipes.com/pound_cake'
              datetime: 1350968400000
            }
          ]

    describe 'when the tag already exists in localStore', ->
      beforeEach ->
        timekeeper.freeze(new Date('10-23-12'))
        @site.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking']
          else if key == 'recipes'
            callback
              'recipes': [
                {
                  title: 'Angel Cake'
                  url: 'http://www.recipes.com/angel_cake'
                  datetime: 1350968400000
                }
              ]

      it 'appends the site to the tag in localStore', ->
        @site.addTag('recipes')
        expect(@site.localStore.set).toHaveBeenCalledWith
          'recipes': [
            {
              title: 'Angel Cake'
              url: 'http://www.recipes.com/angel_cake'
              datetime: 1350968400000
            }, {
              title: 'Pound cake recipes'
              url: 'http://www.recipes.com/pound_cake'
              datetime: 1350968400000
            }
          ]

  describe '#removeTag', ->
    beforeEach ->
      @site.set
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipes'
        tags: ['cooking', 'recipes']

    it 'returns false if the tag is not present in the tags', ->
      expect(@site.removeTag('auto')).toBeFalsy()

    describe 'when the tag is present in the tags', ->
      beforeEach ->
        @site.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking', 'recipes']
          else if key == 'recipes'
            callback
              'recipes': [
                {
                  title: 'Angel Cake'
                  url: 'http://www.recipes.com/angel_cake'
                  datetime: 1350968400000
                }, {
                  title: 'Pound cake recipes'
                  url: 'http://www.recipes.com/pound_cake'
                  datetime: 1350968400000
                }
              ]
      it 'removes the passed tag from the tags attribute', ->
        @site.on 'change:tags', =>
          expect(@site.get('tags')).toEqual ['cooking']
        @site.removeTag('recipes')

      it 'removes the tag from the tags array in localStore', ->
        @site.removeTag('recipes')
        expect(@site.localStore.set).toHaveBeenCalledWith
          'tags': ['cooking']

      it 'removes the site from the tag in localStore', ->
        @site.removeTag('recipes')
        expect(@site.localStore.set).toHaveBeenCalledWith
          'recipes': [
            {
              title: 'Angel Cake'
              url: 'http://www.recipes.com/angel_cake'
              datetime: 1350968400000
            }
          ]
