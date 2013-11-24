describe 'BH.Models.Tag', ->
  beforeEach ->
    global.user = new BH.Models.User
    global.user.login(authId: 123412341234)

    @tag = new BH.Models.Tag name: 'recipes'

  describe '#validate', ->
    it 'creates a validation error when the tag is empty', ->
      @tag.set(name: '    ', {validate: true})
      expect(@tag.validationError).not.toBeUndefined()

    it 'creates a validation error when the tag contains special characters', ->
      @tag.set(name: 'test"', {validate: true})
      expect(@tag.validationError).not.toBeUndefined()

  describe '#fetch', ->
    beforeEach ->
      persistence.tag().fetchTagSites.andCallFake (tag, callback) ->
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
      persistence.tag().removeTag.andCallFake (tag, callback) =>
        callback()

    it 'calls to the persistence layer emptying the sites', ->
      @tag.destroy =>
        expect(@tag.toJSON()).toEqual
          name: 'recipes',
          sites: []

    it 'calls to the sync persistence layer to delete the tag', ->
      @tag.destroy =>
        expect(persistence.remote().deleteTag).toHaveBeenCalledWith('recipes')

    it 'does not call to the sync persistence layer when the user has no authId ', ->
      global.user.logout()
      @tag.destroy =>
        expect(persistence.remote().deleteTag).not.toHaveBeenCalled()

  describe '#removeSite', ->
    beforeEach ->
      persistence.tag().removeSiteFromTag.andCallFake (url, tag, callback) ->
        callback [
          {
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }
        ]

      persistence.tag().fetchSiteTags.andCallFake (url, callback) ->
        callback(['freshly fetched tags'])

      @tag.set sites: [{
        title: 'Pound Cake'
        url: 'http://www.recipes.com/pound_cake'
        datetime: new Date('4/2/13').getTime()
      }, {
        title: 'Angel Food Cake'
        url: 'http://www.recipes.com/food'
        datetime: new Date('4/2/13').getTime()
      }]

    it 'updates the model with local store updates', ->
      @tag.removeSite 'http://www.recipes.com/pound_cake'
      expect(@tag.toJSON()).toEqual
        name: 'recipes',
        sites: [
          {
            title: 'Angel Food Cake'
            url: 'http://www.recipes.com/food'
            datetime: new Date('4/2/13').getTime()
          }
        ]

    it 'calls to the remote persistence layer to update the site', ->
      @tag.removeSite 'http://www.recipes.com/pound_cake'
      expect(persistence.remote().updateSite).toHaveBeenCalledWith
        title: 'Pound Cake'
        url: 'http://www.recipes.com/pound_cake'
        datetime: new Date('4/2/13').getTime()
        tags: ['freshly fetched tags']

    it 'does not call to the remote persistence layer when the user has no authId', ->
      global.user.logout()
      @tag.removeSite 'http://www.recipes.com/pound_cake'
      expect(persistence.remote().updateSite).not.toHaveBeenCalled()

  describe '#renameTag', ->
    beforeEach ->
      persistence.tag().renameTag.andCallFake (oldTag, newTag, callback) ->
        callback()

    it 'calls to the persistence to rename the tag', ->
      @tag.renameTag('baking')
      expect(persistence.tag().renameTag).toHaveBeenCalledWith 'recipes', 'baking', jasmine.any(Function)

    it 'sets the name on the model', ->
      @tag.renameTag 'baking', =>
        expect(@tag.get('name')).toEqual 'baking'

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @tag.renameTag('baking', callback)
      expect(callback).toHaveBeenCalled()

    it 'calls to the sync persistence layer to delete the tag', ->
      @tag.renameTag 'baking', =>
        expect(persistence.remote().renameTag).toHaveBeenCalledWith('recipes', 'baking')

    it 'does not call to the sync persistence layer when the user has no authId ', ->
      global.user.logout()
      @tag.renameTag 'baking', =>
        expect(persistence.remote().renameTag).not.toHaveBeenCalled()
