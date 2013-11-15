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
