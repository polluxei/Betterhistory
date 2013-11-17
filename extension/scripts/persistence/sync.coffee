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

  sync: (sites, callback) ->
    data = JSON.stringify(sites)
    @ajax
      url: "http://#{apiHost}/sync"
      type: "POST"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      data: data
      success: ->
        callback()
      error: (data, type) ->
        alert('There was a problem syncing your tags. Please try again later')
