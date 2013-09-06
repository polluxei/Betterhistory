describe 'BH.Models.Tag', ->
  beforeEach ->
    persistence =
      fetchTagSites: jasmine.createSpy('fetchTagSites')
      removeTag: jasmine.createSpy('removeTag')
      removeSiteFromTag: jasmine.createSpy('removeSiteFromTag')
      renameTag: jasmine.createSpy('renameTag')

    @tag = new BH.Models.Tag name: 'recipes',
      persistence: persistence

  describe '#fetch', ->
    beforeEach ->
      @tag.persistence.fetchTagSites.andCallFake (tag, callback) ->
        callback [
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

    it 'calls to the persistence layer setting the sites', ->
      @tag.fetch =>
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

  describe '#destroy', ->
    beforeEach ->
      @tag.persistence.removeTag.andCallFake (tag, callback) =>
        callback()

    it 'calls to the persistence layer emptying the sites', ->
      @tag.destroy =>
        expect(@tag.toJSON()).toEqual
          name: 'recipes',
          sites: []

  describe '#removeSite', ->
    beforeEach ->
      @tag.persistence.removeSiteFromTag.andCallFake (url, tag, callback) ->
        callback [
          {
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }
        ]

    it 'calls to the persistence layer removing the site', ->
      @tag.removeSite 'http://www.recipes.com/pound_cake', (sites) ->
      expect(@tag.toJSON()).toEqual
        name: 'recipes',
        sites: [
          {
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }
        ]

  describe '#renameTag', ->
    beforeEach ->
      @tag.persistence.renameTag.andCallFake (oldTag, newTag, callback) ->
        callback()

    it 'calls to the persistence to rename the tag', ->
      @tag.renameTag('baking')
      expect(@tag.persistence.renameTag).toHaveBeenCalledWith 'recipes', 'baking', jasmine.any(Function)

    it 'sets the name on the model', ->
      @tag.renameTag 'baking', =>
        expect(@tag.get('name')).toEqual 'baking'

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @tag.renameTag('baking', callback)
      expect(callback).toHaveBeenCalled()
