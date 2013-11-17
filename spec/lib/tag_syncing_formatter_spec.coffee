describe 'BH.Lib.TagSyncingFormatter', ->
  beforeEach ->
    spyOn(BH.Lib.ImageData, 'base64').andCallFake (url, callback) ->
      callback('favicon image')
    @tagSyncingFormatter = new BH.Lib.TagSyncingFormatter()

  describe '#fetchAndFormat', ->
    beforeEach ->
      @tagSyncingFormatter.localStore =
        get: jasmine.createSpy('get').andCallFake (key, callback) ->
          if key == 'tags'
            callback tags:
              ['baking', 'cooking', 'engines', 'camping', 'outdoors', 'travel']
          if _.isEqual key, ['baking', 'cooking', 'engines', 'camping', 'outdoors', 'travel']
            callback ['baking', 'cooking', 'engines', 'camping', 'outdoors', 'travel']
          else if key == 'baking'
            callback baking: [{
              title: 'Baking'
              url: 'http://www.baking.com'
              datetime: 123412341234
            }]
          else if key == 'cooking'
            callback cooking: [{
              title: 'Baking'
              url: 'http://www.baking.com'
              datetime: 123412341234
            }]
          else if key == 'engines'
            callback engines: [{
              title: 'Car repair'
              url: 'http://www.cars.com/repair'
              datetime: 123412341234
            }]
          else if key == 'camping'
            callback camping: [{
              title: 'Camping stuff'
              url: 'http://www.camping.com'
              datetime: 123412341234
            }, {
              title: 'Backpacking'
              url: 'http://www.backpacking.com'
              datetime: 123412341234
            }]
          else if key == 'outdoors'
            callback outdoors: [{
              title: 'Camping stuff'
              url: 'http://www.camping.com'
              datetime: 123412341234
            }]
          else if key == 'travel'
            callback travel: [{
              title: 'Camping stuff'
              url: 'http://www.camping.com'
              datetime: 123412341234
            }]

    it 'returns formatted sites for syncing to the server', ->
      @tagSyncingFormatter.fetchAndFormat (sites) ->
        expect(sites).toEqual [{
          title: 'Baking'
          url: 'http://www.baking.com'
          datetime: 123412341234
          tags: 'baking, cooking'
          image: 'favicon image'
        }, {
          title: 'Car repair'
          url: 'http://www.cars.com/repair'
          datetime: 123412341234
          tags: 'engines'
          image: 'favicon image'
        }, {
          title: 'Camping stuff'
          url: 'http://www.camping.com'
          datetime: 123412341234
          tags: 'camping, outdoors, travel'
          image: 'favicon image'
        }, {
          title: 'Backpacking'
          url: 'http://www.backpacking.com'
          datetime: 123412341234
          tags: 'camping'
          image: 'favicon image'
        }]



