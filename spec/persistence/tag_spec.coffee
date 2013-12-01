describe 'BH.Persistence.Tag', ->
  beforeEach ->
    timekeeper.freeze(new Date(1351029600000))
    localStore =
      get: jasmine.createSpy('get')
      set: jasmine.createSpy('set')
      remove: jasmine.createSpy('remove')
      clear: jasmine.createSpy('clear')

    @persistence = new BH.Persistence.Tag
      localStore: localStore

  describe '#fetchTags', ->
    describe 'when no tags exist', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) =>
          callback {}

      it 'resets the collection to an empty models arrays', ->
        @persistence.fetchTags (tags, compiledTags) ->
          expect(tags).toEqual []
          expect(compiledTags).toEqual []

    describe 'when tags exist', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) =>
          if key == 'tags'
            callback
              tags: ['recipes', 'cooking']
          else if _.isEqual(key, ['recipes', 'cooking'])
            callback recipes: [
              {
                title: 'Pound Cake'
                url: 'http://www.recipes.com/pound_cake'
                datetime: new Date('2/3/12').getTime()
              }, {
                title: 'Angel Food Cake'
                url: 'http://www.recipes.com/food'
                datetime: new Date('4/2/13').getTime()
              }
            ],
            cooking: [
              {
                title: 'Pan Frying'
                url: 'http://www.atk.com/pan_frying'
                datetime: new Date('2/2/12').getTime()
              }, {
                title: 'Baking'
                url: 'http://www.recipes.com/pound_cake'
                datetime: new Date('4/3/12').getTime()
              }]

      it 'returns the found tags and sites', ->
        @persistence.fetchTags (tags, compiledTags) ->
          expect(tags).toEqual ['recipes', 'cooking']
          expect(compiledTags).toEqual [{
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

  describe '#fetchTagSites', ->
    describe 'when the tag does not exist', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) =>
          callback {}

      it 'returns an empty array', ->
        @persistence.fetchTagSites 'recipes', (sites) ->
          expect(sites.length).toEqual 0

    describe 'when the tag exists and is empty', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) =>
          callback recipes: []

      it 'returns an empty array', ->
        @persistence.fetchTagSites 'recipes', (sites) ->
          expect(sites.length).toEqual 0

    describe 'when the tag exists', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) =>
          callback recipes: [
            {
              title: 'Pound Cake'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('2/3/12').getTime()
            }, {
              title: 'Angel Food Cake'
              url: 'http://www.recipes.com/food'
              datetime: new Date('4/2/13').getTime()
            }
          ]

      it 'returns the sites', ->
        @persistence.fetchTagSites 'recipes', (sites) ->
          expect(sites).toEqual [
            {
              title: 'Pound Cake'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('2/3/12').getTime()
            }, {
              title: 'Angel Food Cake'
              url: 'http://www.recipes.com/food'
              datetime: new Date('4/2/13').getTime()
            }
          ]

  describe '#fetchSiteTags', ->
    beforeEach ->
      @url = 'http://www.recipes.com/pound_cake'
      @persistence.localStore.get.andCallFake (key, callback) ->
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

    it 'calls the passed callback w/ the found tags', ->
      @persistence.fetchSiteTags @url, (tags) ->
        expect(tags).toEqual ['recipes', 'cooking']

    describe 'when no tags exist', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback {}

      it 'calls the passed callback w/ an empty array', ->
        @persistence.fetchSiteTags @url, (tags) ->
          expect(tags).toEqual []

  describe '#addSiteToTag', ->
    beforeEach ->
      @site =
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipes'
        datetime: 1351029600000

      @persistence.localStore.get.andCallFake (key, callback) ->
        callback {}

      @persistence.localStore.set.andCallFake (data, callback) ->
        callback()

    describe 'expiring shared tags', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            sharedTags:
              recipes: 'http://www.recipes.com'
              cooking: 'http://www.cooking.com'

      it 'expires the shared tag', ->
        @persistence.addSiteToTag(@site, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          sharedTags:
            cooking: 'http://www.cooking.com'
        }, jasmine.any(Function)

    describe 'when the tag is brand new', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking']
          else if key == 'recipes'
            callback {}

      it 'prepends the tag to the tags key', ->
        @persistence.addSiteToTag(@site, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          tags: ['recipes', 'cooking']
        }, jasmine.any(Function)

      it 'creates the tag with the site in localStore', ->
        @persistence.addSiteToTag(@site, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          recipes: [
            {
              title: 'Pound cake recipes'
              url: 'http://www.recipes.com/pound_cake'
              datetime: 1351029600000
            }
          ]
        }, jasmine.any(Function)

    it 'calls the passed callback with the operations performed', ->
      callback = jasmine.createSpy('callback')
      @persistence.addSiteToTag(@site, 'recipes', callback)
      expect(callback).toHaveBeenCalledWith
        tagCreated: true

    describe 'when the tag already exists in localStore', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking', 'recipes']
          else if key == 'recipes'
            callback
              'recipes': [
                {
                  title: 'Angel Cake'
                  url: 'http://www.recipes.com/angel_cake'
                  datetime: 1351029600000
                }
              ]

      it 'does not add the tag to the tags key', ->
        @persistence.addSiteToTag(@site, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          tags: ['cooking', 'recipes']
        }, jasmine.any(Function)

      it 'appends the site to the tag in localStore', ->
        @persistence.addSiteToTag(@site, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          recipes: [
            {
              title: 'Angel Cake'
              url: 'http://www.recipes.com/angel_cake'
              datetime: 1351029600000
            }, {
              title: 'Pound cake recipes'
              url: 'http://www.recipes.com/pound_cake'
              datetime: 1351029600000
            }
          ]
        }, jasmine.any(Function)

      it 'calls the passed callback with the operations performed', ->
        callback = jasmine.createSpy('callback')
        @persistence.addSiteToTag(@site, 'recipes', callback)
        expect(callback).toHaveBeenCalledWith
          tagCreated: false

  describe '#addSitesToTag', ->
    beforeEach ->
      @sites = [{
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipes'
        datetime: 1351029600000
      }, {
        url: 'http://www.recipes.com/fruit_cake'
        title: 'Fruit cake recipes'
        datetime: 1351029600000
      }]

      @persistence.localStore.get.andCallFake (key, callback) ->
        callback {}

      @persistence.localStore.set.andCallFake (data, callback) ->
        callback()

    describe 'expiring shared tags', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            sharedTags:
              recipes: 'http://www.recipes.com'
              cooking: 'http://www.cooking.com'

      it 'expires the shared tag', ->
        @persistence.addSitesToTag(@sites, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          sharedTags:
            cooking: 'http://www.cooking.com'
        }, jasmine.any(Function)

    describe 'when the tag does not exist', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking']
          else if key == 'recipes'
            callback {}

      it 'prepends the tag to the tag key', ->
        @persistence.addSitesToTag(@sites, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          tags: ['recipes', 'cooking']
        }, jasmine.any(Function)

      it 'creates the tag with the site', ->
        @persistence.addSitesToTag(@sites, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          recipes: [
            {
              url: 'http://www.recipes.com/pound_cake'
              title: 'Pound cake recipes'
              datetime: 1351029600000
            }, {
              title: 'Fruit cake recipes'
              url: 'http://www.recipes.com/fruit_cake'
              datetime: 1351029600000
            }
          ]
        }, jasmine.any(Function)

      it 'calls the passed callback with the operations performed', ->
        callback = jasmine.createSpy('callback')
        @persistence.addSitesToTag(@sites, 'recipes', callback)
        expect(callback).toHaveBeenCalledWith
          tagCreated: true

    describe 'when the tag exists', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking', 'recipes']
          else if key == 'recipes'
            callback
              'recipes': [
                {
                  title: 'Angel Cake'
                  url: 'http://www.recipes.com/angel_cake'
                  datetime: 1351029600000
                }
              ]

      it 'does not add the tag to the tag key', ->
        @persistence.addSitesToTag @sites, 'recipes'
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          tags: ['cooking', 'recipes']
        }, jasmine.any(Function)

      it 'appends the site to the tag', ->
        @persistence.addSitesToTag(@sites, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          recipes: [
            {
              title: 'Angel Cake'
              url: 'http://www.recipes.com/angel_cake'
              datetime: 1351029600000
            }, {
              title: 'Pound cake recipes'
              url: 'http://www.recipes.com/pound_cake'
              datetime: 1351029600000
            }, {
              title: 'Fruit cake recipes'
              url: 'http://www.recipes.com/fruit_cake'
              datetime: 1351029600000
            }
          ]
        }, jasmine.any(Function)

      it 'calls the passed callback with the operations performed', ->
        callback = jasmine.createSpy('callback')
        @persistence.addSitesToTag(@sites, 'recipes', callback)
        expect(callback).toHaveBeenCalledWith
          tagCreated: false

  describe '#clearAll', ->
    it 'calls to localStore to clear everything', ->
      @persistence.clearAll()
      expect(@persistence.localStore.clear).toHaveBeenCalled()

  describe '#removeTag', ->
    beforeEach ->
      @persistence.localStore.get.andCallFake (key, callback) =>
        if key == 'tags'
          callback tags: ['recipes', 'cooking']
      @persistence.localStore.set.andCallFake (key, callback) =>
        callback()
      @persistence.localStore.remove.andCallFake (key, callback) =>
        callback()

    describe 'expiring shared tags', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            sharedTags:
              recipes: 'http://www.recipes.com'
              cooking: 'http://www.cooking.com'

      it 'expires the shared tag', ->
        @persistence.removeTag('recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          sharedTags:
            cooking: 'http://www.cooking.com'
        }, jasmine.any(Function)

    it 'removes the tag from the tags key', ->
      @persistence.removeTag('recipes')
      expect(@persistence.localStore.set).toHaveBeenCalledWith {tags: ['cooking']}, jasmine.any(Function)

    it 'removes the tag data', ->
      @persistence.removeTag('recipes')
      expect(@persistence.localStore.remove).toHaveBeenCalledWith 'recipes', jasmine.any(Function)

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @persistence.removeTag('recipes', callback)
      expect(callback).toHaveBeenCalled()

  describe '#removeSiteFromTag', ->
    beforeEach ->
      @url = 'http://www.recipes.com/pound_cake'

    describe 'expiring shared tags', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            sharedTags:
              recipes: 'http://www.recipes.com'
              cooking: 'http://www.cooking.com'

      it 'expires the shared tag', ->
        @persistence.removeSiteFromTag(@url, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          sharedTags:
            cooking: 'http://www.cooking.com'
        }, jasmine.any(Function)

    describe 'when the site is present in the tag', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
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
        @persistence.localStore.set.andCallFake (key, callback) =>
          callback()

      it 'removes the site from the tag in localStore', ->
        @persistence.removeSiteFromTag(@url, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith
          recipes: [{
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }]
        , jasmine.any(Function)

      it 'calls the passed callback with the new sites', ->
        callback = jasmine.createSpy('callback')
        @persistence.removeSiteFromTag(@url, 'recipes', callback)
        expect(callback).toHaveBeenCalledWith [
          {
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }
        ]

    describe 'when the site is not present in the tag', ->
      beforeEach ->
        @url = 'http://www.recipes.com/chocolate_cake'

        @persistence.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking', 'recipes']
          else if key == 'recipes'
            callback
              'recipes': [
                {
                  title: 'Angel Cake'
                  url: 'http://www.recipes.com/angel_cake'
                  datetime: 1351029600000
                }, {
                  title: 'Pound cake recipes'
                  url: 'http://www.recipes.com/pound_cake'
                  datetime: 1351029600000
                }
              ]

      it 'does not modify the tagged sites in localStore', ->
        @persistence.removeSiteFromTag(@url, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          recipes: [
            {
              title: 'Angel Cake'
              url: 'http://www.recipes.com/angel_cake'
              datetime: 1351029600000
            }, {
              title: 'Pound cake recipes'
              url: 'http://www.recipes.com/pound_cake'
              datetime: 1351029600000
            }
          ]
        }, jasmine.any(Function)

  describe '#removeSitesFromTag', ->
    beforeEach ->
      @urls = [
        'http://www.recipes.com/pound_cake',
        'http://www.recipes.com/fruit_cake'
      ]

    describe 'expiring shared tags', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            sharedTags:
              recipes: 'http://www.recipes.com'
              cooking: 'http://www.cooking.com'

      it 'expires the shared tag', ->
        @persistence.removeSitesFromTag(@url, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          sharedTags:
            cooking: 'http://www.cooking.com'
        }, jasmine.any(Function)

    describe 'when the sites are present in the tag', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            recipes: [{
              title: 'Pound Cake'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('2/3/12').getTime()
            }, {
              title: 'Fruit Cake'
              url: 'http://www.recipes.com/fruit_cake'
              datetime: new Date('2/3/12').getTime()
            }, {
              title: 'Angel Food Cake'
              url: 'http://www.recipes.com/food'
              datetime: new Date('4/2/13').getTime()
            }]
        @persistence.localStore.set.andCallFake (key, callback) =>
          callback()

      it 'removes the sites from the tag in localStore', ->
        @persistence.removeSitesFromTag(@urls, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith
          recipes: [{
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }]
        , jasmine.any(Function)

      it 'calls the passed callback with the new sites', ->
        callback = jasmine.createSpy('callback')
        @persistence.removeSitesFromTag(@urls, 'recipes', callback)
        expect(callback).toHaveBeenCalledWith [
          {
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }
        ]

    describe 'when the sites is not present in the tag', ->
      beforeEach ->
        @urls = ['http://www.recipes.com/chocolate_cake']

        @persistence.localStore.get.andCallFake (key, callback) ->
          if key == 'tags'
            callback
              tags: ['cooking', 'recipes']
          else if key == 'recipes'
            callback
              'recipes': [
                {
                  title: 'Angel Cake'
                  url: 'http://www.recipes.com/angel_cake'
                  datetime: 1351029600000
                }, {
                  title: 'Pound cake recipes'
                  url: 'http://www.recipes.com/pound_cake'
                  datetime: 1351029600000
                }
              ]

      it 'does not modify the tagged sites in localStore', ->
        @persistence.removeSitesFromTag(@urls, 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          recipes: [
            {
              title: 'Angel Cake'
              url: 'http://www.recipes.com/angel_cake'
              datetime: 1351029600000
            }, {
              title: 'Pound cake recipes'
              url: 'http://www.recipes.com/pound_cake'
              datetime: 1351029600000
            }
          ]
        }, jasmine.any(Function)

  describe '#addSitesToTag', ->
    beforeEach ->
      @persistence.localStore.get.andCallFake (key, callback) ->
        callback {}
      @persistence.localStore.set.andCallFake (data, callback) ->
        callback {}

    it 'calls the passed callback when all sites have been tagged', ->
      sites = ['site1', 'site2']
      callback = jasmine.createSpy('callback')
      @persistence.addSitesToTag(sites, 'recipes', callback)
      expect(callback).toHaveBeenCalled()


  describe '#removeAllTags', ->
    beforeEach ->
      @persistence.localStore.get.andCallFake (key, callback) =>
        if key == 'tags'
          callback tags: ['recipes', 'cooking']
      @persistence.localStore.set.andCallFake (data, callback) ->
        callback()
      @persistence.localStore.remove.andCallFake (keys, callback) ->
        callback()

    describe 'expiring shared tags', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            sharedTags:
              recipes: 'http://www.recipes.com'
              cooking: 'http://www.cooking.com'

      it 'expires all the shared tag', ->
        @persistence.removeAllTags()
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          sharedTags: {}
        }, jasmine.any(Function)

    it 'removes all the tag data', ->
      @persistence.removeAllTags()
      expect(@persistence.localStore.remove).toHaveBeenCalledWith ['recipes', 'cooking'], jasmine.any(Function)

    it 'sets the tag key to an empty array', ->
      @persistence.removeAllTags()
      expect(@persistence.localStore.set).toHaveBeenCalledWith {tags: []}, jasmine.any(Function)

    it 'calls the passed the callback', ->
      callback = jasmine.createSpy('callback')
      @persistence.removeAllTags(callback)
      expect(callback).toHaveBeenCalled()

  describe '#renameTag', ->
    beforeEach ->
      @persistence.localStore.get.andCallFake (key, callback) =>
        if key == 'tags'
          callback tags: ['sports', 'recipes', 'cooking']
        else if key == 'cooking'
          callback cooking: [
            {
              title: 'Pan Frying'
              url: 'http://www.atk.com/pan_frying'
              datetime: new Date('2/2/12').getTime()
            }, {
              title: 'Baking'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('4/3/12').getTime()
            }
          ]
        else if key == 'recipes'
          callback recipes: [
            {
              title: 'Key lime pie',
              url: 'http://www.atk.com/key_pie',
              datetime: new Date('4/3/12').getTime()
            }
          ]

      @persistence.localStore.set.andCallFake (data, callback) =>
        callback()
      @persistence.localStore.remove.andCallFake (keys, callback) =>
        callback()

    describe 'expiring shared tags', ->
      beforeEach ->
        @persistence.localStore.get.andCallFake (key, callback) ->
          callback
            sharedTags:
              recipes: 'http://www.recipes.com'
              cooking: 'http://www.cooking.com'

      it 'expires the shared tag', ->
        @persistence.renameTag('cooking', 'baking')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          sharedTags:
            recipes: 'http://www.recipes.com'
        }, jasmine.any(Function)

    it 'removes the old tag', ->
      @persistence.renameTag('cooking', 'baking')
      expect(@persistence.localStore.remove).toHaveBeenCalledWith 'cooking', jasmine.any(Function)

    describe 'when the new tag does not exist', ->
      it 'updates the tag keys with the new tag name', ->
        @persistence.renameTag('cooking', 'baking')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {tags: ['baking', 'sports', 'recipes']}, jasmine.any(Function)

      it 'creates the new tag with the old tag content', ->
        @persistence.renameTag('cooking', 'baking')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          baking: [
            {
              title: 'Pan Frying'
              url: 'http://www.atk.com/pan_frying'
              datetime: new Date('2/2/12').getTime()
            }, {
              title: 'Baking'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('4/3/12').getTime()
            }
          ]
        }, jasmine.any(Function)

    describe 'when the new tag does exist', ->
      it 'removes the old tag from the tags key', ->
        @persistence.renameTag('cooking', 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {tags: ['recipes', 'sports']}, jasmine.any(Function)

      it 'merges the old and new tag content', ->
        @persistence.renameTag('cooking', 'recipes')
        expect(@persistence.localStore.set).toHaveBeenCalledWith {
          recipes: [
            {
              title: 'Key lime pie',
              url: 'http://www.atk.com/key_pie',
              datetime: new Date('4/3/12').getTime()
            }, {
              title: 'Pan Frying'
              url: 'http://www.atk.com/pan_frying'
              datetime: new Date('2/2/12').getTime()
            }, {
              title: 'Baking'
              url: 'http://www.recipes.com/pound_cake'
              datetime: new Date('4/3/12').getTime()
            }
          ]
        }, jasmine.any(Function)

