describe 'BH.Persistence.Sync', ->
  beforeEach ->
    @sync = new BH.Persistence.Sync '123123123', jasmine.createSpy('ajax')

  describe '#updateSite', ->
    it 'calls to ajax with stringified site data', ->
      @sync.updateSite
        url: 'http://www.camping'
        title: 'Camping the World'
        datetime: 1231234
        tags: ['camping', 'outdoors']

      expect(@sync.ajax).toHaveBeenCalledWith
        url: 'http://api.better-history.com/site'
        type: 'POST'
        contentType: 'application/json'
        dataType: 'json'
        headers:
          authorization: '123123123'
        data: '{"url":"http://www.camping","title":"Camping the World","datetime":1231234,"tags":["camping","outdoors"]}'

  describe '#sync', ->
    it 'calls to ajax with stringified tag rename data', ->
      data = [{
        title: 'camping'
        url: 'http://www.camping.com'
        datetime: 123123123123
        image: 'favicon base64'
        tags: 'camping, outdoors'
      }, {
        title: 'cars'
        url: 'http://www.cars.com'
        datetime:123123123123
        image: 'favicon base64'
        tags: 'engines, cars, auto'
      }]

      @sync.sync data
      expect(@sync.ajax).toHaveBeenCalledWith
        url: 'http://api.better-history.com/sync'
        type: 'POST'
        contentType: 'application/json'
        dataType: 'text'
        headers:
          authorization: '123123123'
        data: '[{"title":"camping","url":"http://www.camping.com","datetime":123123123123,"image":"favicon base64","tags":"camping, outdoors"},{"title":"cars","url":"http://www.cars.com","datetime":123123123123,"image":"favicon base64","tags":"engines, cars, auto"}]'
        error: jasmine.any(Function)
        success: jasmine.any(Function)

  describe '#renameTag', ->
    it 'calls to ajax with stringified tag rename data', ->
      @sync.renameTag('cooking', 'baking')
      expect(@sync.ajax).toHaveBeenCalledWith
        url: 'http://api.better-history.com/tags/cooking/rename'
        type: 'PUT'
        contentType: 'application/json'
        dataType: 'text'
        headers:
          authorization: '123123123'
        data: '{"name":"baking"}'
        error: jasmine.any(Function)

  describe '#deleteTag', ->
    it 'calls to ajax to delete a tag', ->
      @sync.deleteTag('cooking')
      expect(@sync.ajax).toHaveBeenCalledWith
        url: 'http://api.better-history.com/tags/cooking'
        type: 'DELETE'
        contentType: 'application/json'
        dataType: 'text'
        headers:
          authorization: '123123123'
        error: jasmine.any(Function)
