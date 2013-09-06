describe 'BH.Models.Site', ->
  beforeEach ->
    persistence =
      fetchSiteTags: jasmine.createSpy('fetchSiteTags')
      addSiteToTag: jasmine.createSpy('addSiteToTag')
      removeSiteFromTag: jasmine.createSpy('removeSiteFromTag')

    @site = new BH.Models.Site {},
      chrome: chrome
      persistence: persistence

  describe '#fetch', ->
    beforeEach ->
      tabs = [{
        url: 'http://www.recipes.com/pound_cake'
        title: 'Pound cake recipe'
      }]
      chrome.tabs.query.andCallFake (options, callback) ->
        callback(tabs)

      @site.persistence.fetchSiteTags.andCallFake (url, callback) ->
        callback ['recipes', 'cooking']

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
        expect(@site.persistence.addSiteToTag).toHaveBeenCalledWith(site, 'recipes')

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
