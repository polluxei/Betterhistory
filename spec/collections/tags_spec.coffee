describe 'BH.Collections.Tags', ->
  beforeEach ->
    persistence =
      fetchTags: jasmine.createSpy('fetchTags')
      removeAllTags: jasmine.createSpy('removeAllTags')

    @tags = new BH.Collections.Tags [],
      persistence: persistence

  describe '#fetch', ->
    beforeEach ->
      @tags.persistence.fetchTags.andCallFake (callback) ->
        callback ['recipes', 'cooking'], [
          {
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
          }
        ]

    it 'fetchs the tags from the persistence layer', ->
      @tags.fetch()
      expect(@tags.persistence.fetchTags).toHaveBeenCalledWith jasmine.any(Function)

    it 'calls the passed callback', ->
      callback = jasmine.createSpy('callback')
      @tags.fetch(callback)
      expect(callback).toHaveBeenCalled()

    it 'sets the tags on the model', ->
      @tags.fetch =>
        expect(@tags.models.length).toEqual 2

    it 'stores the tag order on the model', ->
      @tags.fetch =>
        expect(@tags.tagOrder).toEqual ['recipes', 'cooking']

  describe '#destroy', ->
    it 'removes all the tag data and the keys key', ->
      @tags.destroy()
      expect(@tags.persistence.removeAllTags).toHaveBeenCalledWith jasmine.any(Function)
