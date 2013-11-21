error = (data, type) ->
  alert('There was a problem syncing your tags. Please try again later')

class BH.Persistence.Sync
  constructor: (@authId, @ajax) ->

  host: ->
    "http://#{apiHost}"

  updateSite: (site) ->
    data = JSON.stringify(site)
    @ajax
      url: "#{@host()}/user/site"
      type: "POST"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      data: data
      error: error

  updateSites: (sites, callback = ->) ->
    data = JSON.stringify(sites)
    @ajax
      url: "#{@host()}/user/sites"
      type: "POST"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      data: data
      success: ->
        callback()
      error: error

  getSites: (callback) ->
    @ajax
      url: "#{@host()}/user/sites"
      type: "GET"
      contentType: 'application/json'
      dataType: 'json'
      headers:
        authorization: @authId
      success: (data) ->
        callback(data)
      error: error

  renameTag: (oldName, newName) ->
    data = JSON.stringify(name: newName)
    @ajax
      url: "#{@host()}/user/tags/#{oldName}/rename"
      type: "PUT"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      data: data
      error: error

  deleteTag: (name) ->
    @ajax
      url: "#{@host()}/user/tags/#{name}"
      type: "DELETE"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      error: error

  deleteSites: (callback = ->) ->
    @ajax
      url: "#{@host()}/user/sites"
      type: "DELETE"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      error: error
      success: ->
        callback()
