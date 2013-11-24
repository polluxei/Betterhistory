describe 'BH.Models.Site', ->
  beforeEach ->
    global.user = new BH.Models.User
    global.user.login(authId: 123412341234)

    persistence.tag().addSiteToTag.andCallFake (site, tag, cb) ->
      cb()

    attrs =
      url: 'http://www.recipes.com/pound_cake'
      title: 'Pound cake recipe'

    @site = new BH.Models.Site attrs,
      chrome: chrome

  describe '#fetch', ->
    beforeEach ->
      persistence.tag().fetchSiteTags.andCallFake (url, callback) ->
        callback ['recipes', 'cooking']

    it 'sets the site attributes and collects it\'s tags', ->
      @site.fetch()
      expect(@site.toJSON()).toEqual
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipe'
        tags: ['recipes', 'cooking']

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @site.fetch(callback)
      expect(callback).toHaveBeenCalled()

  describe '#tags', ->
    it 'returns the tags set', ->
      @site.set tags: ['recipes', 'baking']
      expect(@site.tags()).toEqual ['recipes', 'baking']

  describe '#addTag', ->
    beforeEach ->
      @callback = jasmine.createSpy('callback')
      @site.set
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipes'
        tags: ['cooking']

    it 'calls the callback with false if the tag is found in the tags', ->
      @site.addTag('cooking', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)

    it 'returns false if the tag is empty', ->
      @site.addTag('   ', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)

    it 'returns false if the tag contains special characters', ->
      @site.addTag('test"', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)
      @site.addTag('\'test', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)
      @site.addTag('{test}"', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)
      @site.addTag('~test"', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)
      @site.addTag('t%est"', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)
      @site.addTag('<test>"', @callback)
      expect(@callback).toHaveBeenCalledWith(false, null)

    describe 'when the tag is valid', ->
      it 'adds the passed tag to the tags attribute', ->
        @site.on 'change:tags', =>
          expect(@site.get('tags')).toEqual ['cooking', 'recipes']
        @site.addTag('recipes')

      it 'calls to the persistence layer to add the tag', ->
        @site.addTag('recipes')
        site =
          url: @site.get('url')
          title: @site.get('title')
        expect(persistence.tag().addSiteToTag).toHaveBeenCalledWith(site, 'recipes', jasmine.any(Function))

      it 'calls to the sync persistence layer to update the site', ->
        @site.addTag('recipes')

        expect(persistence.remote().updateSite).toHaveBeenCalledWith
          url: 'http://www.recipes.com/pound_cake'
          title: 'Pound cake recipes'
          datetime: undefined
          tags: ['cooking', 'recipes']

      it 'does not call to the sync persistence layer when the user has no authId ', ->
        global.user.logout()
        @site.addTag('recipes')

        expect(persistence.remote().updateSite).not.toHaveBeenCalled()

      it 'calls the passed callback with the result and operations performed during the persistence', ->
        callback = jasmine.createSpy('callback')
        persistence.tag().addSiteToTag.andCallFake (site, tag, callback) ->
          callback('operations')
        @site.addTag('recipes', callback)
        expect(callback).toHaveBeenCalledWith(true, 'operations')

  describe '#removeTag', ->
    beforeEach ->
      @site.set
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipes'
        tags: ['cooking', 'recipes']

    it 'returns false if the tag is not present in the tags', ->
      expect(@site.removeTag('auto')).toEqual false

    describe 'when the tag is present in the tags', ->
      it 'removes the passed tag from the tags attribute', ->
        @site.on 'change:tags', =>
          expect(@site.get('tags')).toEqual ['cooking']
        @site.removeTag('recipes')

      it 'calls to the sync persistence layer to update the site', ->
        @site.removeTag('recipes')

        expect(persistence.remote().updateSite).toHaveBeenCalledWith
          url: 'http://www.recipes.com/pound_cake'
          title: 'Pound cake recipes'
          datetime: undefined
          tags: ['cooking']

      it 'does not call to the sync persistence layer when the user has no authId ', ->
        global.user.logout()
        @site.removeTag('recipes')
        expect(persistence.remote().updateSite).not.toHaveBeenCalled()


      it 'calls to the persistence layer to remove the tag', ->
        @site.removeTag('recipes')
        expect(persistence.tag().removeSiteFromTag).toHaveBeenCalledWith(@site.get('url'), 'recipes')

