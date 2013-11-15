describe 'BH.Persistence.Share', ->
  beforeEach ->
    remote = jasmine.createSpy('remote')
    @share = new BH.Persistence.Share(remote)

  describe '#send', ->
    beforeEach ->
      @tag =
        name: 'clothes',
        sites: [{
          title: 'nice clothes'
          url: 'http://www.nice-clothes.com'
          datetime: 1234234234342
        }]

    it 'calls to remote with the request properties', ->
      @share.send(@tag)
      data = '{"name":"clothes","sites":[{"title":"nice clothes","url":"http://www.nice-clothes.com","datetime":1234234234342}]}'
      expect(@share.remote).toHaveBeenCalledWith
        url: "http://api.better-history.com/share"
        data: data
        type: 'POST'
        dataType: 'json'
        contentType: 'application/json'
        success: jasmine.any(Function)
        error: jasmine.any(Function)
