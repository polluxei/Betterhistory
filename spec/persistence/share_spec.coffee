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
      expect(@share.remote(@tag)).toHaveBeenCalledWith
        url: "http://127.0.0.1:3000/share"
        data: @tag
        type: 'POST'
        dataType: 'json'
        contentType: 'application/json'
        success: jasmine.any(Function)
        error: jasmine.any(Function)
