describe 'BH.Models.Tag', ->
  beforeEach ->
    global.user = new BH.Models.User
    global.user.login(authId: 123412341234)

    persistence =
      fetchTagSites: jasmine.createSpy('fetchTagSites')
      removeTag: jasmine.createSpy('removeTag')
      removeSiteFromTag: jasmine.createSpy('removeSiteFromTag')
      renameTag: jasmine.createSpy('renameTag')
      fetchSharedTag: jasmine.createSpy('fetchSharedTag')

    sync =
      renameTag: jasmine.createSpy('renameTag')
      deleteTag: jasmine.createSpy('deleteTag')

    @tag = new BH.Models.Tag name: 'recipes',
      persistence: persistence
      syncPersistence: sync

  describe '#validate', ->
    it 'creates a validation error when the tag is empty', ->
      @tag.set(name: '    ', {validate: true})
      expect(@tag.validationError).not.toBeUndefined()

    it 'creates a validation error when the tag contains special characters', ->
      @tag.set(name: 'test"', {validate: true})
      expect(@tag.validationError).not.toBeUndefined()

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

    it 'calls to the sync persistence layer to delete the tag', ->
      @tag.destroy =>
        expect(@tag.syncPersistence.deleteTag).toHaveBeenCalledWith('recipes')

    it 'does not call to the sync persistence layer when the user has no authId ', ->
      global.user.logout()
      @tag.destroy =>
        expect(@tag.syncPersistence.deleteTag).not.toHaveBeenCalled()

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

    it 'calls to the sync persistence layer to delete the tag', ->
      @tag.renameTag 'baking', =>
        expect(@tag.syncPersistence.renameTag).toHaveBeenCalledWith('recipes', 'baking')

    it 'does not call to the sync persistence layer when the user has no authId ', ->
      global.user.logout()
      @tag.renameTag 'baking', =>
        expect(@tag.syncPersistence.renameTag).not.toHaveBeenCalled()

