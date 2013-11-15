class BH.Persistence.Sync
  constructor: (@authId, @ajax) ->

  updateSite: (site) ->
    data = JSON.stringify(site)
    @ajax
      url: "http://#{apiHost}/site"
      type: "POST"
      contentType: 'application/json'
      dataType: 'json'
      headers:
        authorization: @authId
      data: data
