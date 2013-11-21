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
        url: 'http://api.better-history.com/user/site'
        type: 'POST'
        contentType: 'application/json'
        dataType: 'text'
        headers:
          authorization: '123123123'
        data: '{"url":"http://www.camping","title":"Camping the World","datetime":1231234,"tags":["camping","outdoors"]}'
        error: jasmine.any(Function)

  describe '#updateSites', ->
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

      @sync.updateSites data
      expect(@sync.ajax).toHaveBeenCalledWith
        url: 'http://api.better-history.com/user/sites'
        type: 'POST'
        contentType: 'application/json'
        dataType: 'text'
        headers:
          authorization: '123123123'
        data: '[{"title":"camping","url":"http://www.camping.com","datetime":123123123123,"image":"favicon base64","tags":"camping, outdoors"},{"title":"cars","url":"http://www.cars.com","datetime":123123123123,"image":"favicon base64","tags":"engines, cars, auto"}]'
        error: jasmine.any(Function)
        success: jasmine.any(Function)

  describe '#getSites', ->
    it 'calls to ajax to get all the sites', ->
      @sync.getSites()
      expect(@sync.ajax).toHaveBeenCalledWith
        url: 'http://api.better-history.com/user/sites'
        type: 'GET'
        contentType: 'application/json'
        dataType: 'json'
        headers:
          authorization: '123123123'
        error: jasmine.any(Function)
        success: jasmine.any(Function)

  describe '#renameTag', ->
    it 'calls to ajax with stringified tag rename data', ->
      @sync.renameTag('cooking', 'baking')
      expect(@sync.ajax).toHaveBeenCalledWith
        url: 'http://api.better-history.com/user/tags/cooking/rename'
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
        url: 'http://api.better-history.com/user/tags/cooking'
        type: 'DELETE'
        contentType: 'application/json'
        dataType: 'text'
        headers:
          authorization: '123123123'
        error: jasmine.any(Function)
