describe 'BH.Lib.SyncingTranslator', ->
  beforeEach ->
    @syncingTranslator = new BH.Lib.SyncingTranslator()

  describe '#forServer', ->
    beforeEach ->
      @compiledTags =
        tags: ['baking', 'cooking', 'engines', 'camping', 'outdoors', 'travel']
        baking: [
          {
            title: 'Baking'
            url: 'http://www.baking.com'
            datetime: 123412341234
          }
        ]
        cooking: [
          {
            title: 'Baking'
            url: 'http://www.baking.com'
            datetime: 123412341234
          }
        ]
        engines: [
          {
            title: 'Car repair'
            url: 'http://www.cars.com/repair'
            datetime: 123412341234
          }
        ]
        camping: [
          {
            title: 'Camping stuff'
            url: 'http://www.camping.com'
            datetime: 123412341234
          }, {
            title: 'Backpacking'
            url: 'http://www.backpacking.com'
            datetime: 123412341234
          }
        ]
        outdoors: [
          {
            title: 'Camping stuff'
            url: 'http://www.camping.com'
            datetime: 123412341234
          }
        ]
        travel: [
          {
            title: 'Camping stuff'
            url: 'http://www.camping.com'
            datetime: 123412341234
          }
        ]

    it 'returns formatted sites for syncing to the server', ->
      @syncingTranslator.forServer @compiledTags, (sites) ->
        expect(sites).toEqual [{
          title: 'Baking'
          url: 'http://www.baking.com'
          datetime: 123412341234
          tags: ['baking', 'cooking']
          image: 'favicon image'
        }, {
          title: 'Car repair'
          url: 'http://www.cars.com/repair'
          datetime: 123412341234
          tags: ['engines']
          image: 'favicon image'
        }, {
          title: 'Camping stuff'
          url: 'http://www.camping.com'
          datetime: 123412341234
          tags: ['camping', 'outdoors', 'travel']
          image: 'favicon image'
        }, {
          title: 'Backpacking'
          url: 'http://www.backpacking.com'
          datetime: 123412341234
          tags: ['camping']
          image: 'favicon image'
        }]

  describe '#forLocal', ->
    beforeEach ->
      @sites = [{
        title: 'Baking'
        url: 'http://www.baking.com'
        datetime: 123412341234
        tags: ['baking', 'cooking']
        image: 'favicon image'
      }, {
        title: 'Car repair'
        url: 'http://www.cars.com/repair'
        datetime: 123412341234
        tags: ['engines']
        image: 'favicon image'
      }, {
        title: 'Camping stuff'
        url: 'http://www.camping.com'
        datetime: 123412341234
        tags: ['camping', 'outdoors', 'travel']
        image: 'favicon image'
      }, {
        title: 'Backpacking'
        url: 'http://www.backpacking.com'
        datetime: 123412341234
        tags: ['camping']
        image: 'favicon image'
      }]
    it 'returns formatted sites for syncing to the server', ->
      compiledTags = @syncingTranslator.forLocal(@sites)
      expect(compiledTags).toEqual
        tags: ['baking', 'cooking', 'engines', 'camping', 'outdoors', 'travel']
        baking: [{
          title: 'Baking'
          url: 'http://www.baking.com'
          datetime: 123412341234
        }]
        cooking: [{
          title: 'Baking'
          url: 'http://www.baking.com'
          datetime: 123412341234
        }]
        engines: [{
          title: 'Car repair'
          url: 'http://www.cars.com/repair'
          datetime: 123412341234
        }]
        camping: [{
          title: 'Camping stuff'
          url: 'http://www.camping.com'
          datetime: 123412341234
        }, {
          title: 'Backpacking'
          url: 'http://www.backpacking.com'
          datetime: 123412341234
        }]
        outdoors: [{
          title: 'Camping stuff'
          url: 'http://www.camping.com'
          datetime: 123412341234
        }]
        travel: [{
          title: 'Camping stuff'
          url: 'http://www.camping.com'
          datetime: 123412341234
        }]
