describe 'BH.Models.Site', ->
  beforeEach ->
    persistence =
      fetchSiteTags: jasmine.createSpy('fetchSiteTags')
      addSiteToTag: jasmine.createSpy('addSiteToTag')
      removeSiteFromTag: jasmine.createSpy('removeSiteFromTag')

    attrs =
      url: 'http://www.recipes.com/pound_cake'
      title: 'Pound cake recipe'

    @site = new BH.Models.Site attrs,
      chrome: chrome
      persistence: persistence

  describe '#fetch', ->
    beforeEach ->
      @site.persistence.fetchSiteTags.andCallFake (url, callback) ->
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
      @site.set
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipes'
        tags: ['cooking']

    it 'returns false if the tag is found in the tags', ->
      expect(@site.addTag('cooking')).toEqual false

    it 'returns false if the tag is empty', ->
      expect(@site.addTag('   ')).toEqual false

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
        expect(@site.persistence.addSiteToTag).toHaveBeenCalledWith(site, 'recipes', jasmine.any(Function))

      it 'calls the passed callback with the result and operations performed during the persistence', ->
        callback = jasmine.createSpy('callback')
        @site.persistence.addSiteToTag.andCallFake (site, tag, callback) ->
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

      it 'calls to the persistence layer to remove the tag', ->
        @site.removeTag('recipes')
        expect(@site.persistence.removeSiteFromTag).toHaveBeenCalledWith(@site.get('url'), 'recipes')
