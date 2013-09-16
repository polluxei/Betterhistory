describe 'BH.Collections.Site', ->
  beforeEach ->
    persistence =
      addSitesToTag: jasmine.createSpy('addSitesToTag').andCallFake (sites, tag, callback) ->
        callback()
      removeSitesFromTag: jasmine.createSpy('removeSitesFromTag').andCallFake (sites, tag, callback) ->
        callback()
    @sites = new BH.Collections.Sites [],
      persistence: persistence

    attrs = [{
      title: 'Pies',
      url: 'http://www.atk.com/pies',
      tags: ['cooking', 'desserts']
    }, {
      title: 'Sandwiches',
      url: 'http://www.atk.com/sandwiches',
      tags: ['bread', 'cooking']
    }, {
      title: 'Turkey',
      url: 'http://www.atk.com/turkey',
      tags: ['recipes', 'cooking']
    }]

    @sites.add attrs,
      chrome: {}
      persistence: {}

    @sites.each (site) ->
      spyOn(site, 'fetch').andCallFake (callback) ->
        callback()

  describe '#fetch', ->
    beforeEach ->
      spyOn(@sites, 'trigger')

    it 'triggers a change event for all tags', ->
      @sites.fetch()
      expect(@sites.trigger).toHaveBeenCalledWith('change:allTags')

  describe '#sharedTags', ->
    it 'returns an array of tags that all sites have in common', ->
      expect(@sites.sharedTags()).toEqual ['cooking']

  describe '#addTag', ->
    it 'returns false if the tag is empty', ->
      expect(@sites.addTag('   ')).toEqual false

    describe 'when the tag is valid', ->
      it 'adds the passed tag to the tags attribute', ->
        @sites.addTag 'recipes', =>
          expect(@sites.pluck('tags')).toEqual [
            ['cooking', 'desserts', 'recipes'],
            ['bread', 'cooking', 'recipes'],
            ['recipes', 'cooking']
          ]

      it 'calls to the persistence layer to add the tag to sites that do not already have the tag', ->
        @sites.addTag('recipes')
        sites = [{
          title: 'Pies'
          url: 'http://www.atk.com/pies'
        }, {
          title: 'Sandwiches'
          url: 'http://www.atk.com/sandwiches'
        }]
        expect(@sites.persistence.addSitesToTag).toHaveBeenCalledWith(sites, 'recipes', jasmine.any(Function))

  describe '#removeTag', ->
    describe 'when the tag is present in the tags', ->
      it 'removes the passed tag from the tags attribute', ->
        @sites.removeTag 'cooking', =>
          expect(@sites.pluck('tags')).toEqual [
            ['desserts'],
            ['bread'],
            ['recipes']
          ]

      it 'calls to the persistence layer to remove the tag from sites that originally had it', ->
        @sites.removeTag('cooking')
        sites = [
          'http://www.atk.com/pies',
          'http://www.atk.com/sandwiches',
          'http://www.atk.com/turkey'
        ]
        expect(@sites.persistence.removeSitesFromTag).toHaveBeenCalledWith(sites, 'cooking', jasmine.any(Function))

  describe '#tags', ->
    it 'returns all the shared tags', ->
      expect(@sites.tags()).toEqual ['cooking']

  describe '#sharedTags', ->
    it 'returns all the shared tags', ->
      expect(@sites.sharedTags()).toEqual ['cooking']
