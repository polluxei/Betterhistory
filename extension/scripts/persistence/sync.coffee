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

  renameTag: (oldName, newName) ->
    data = JSON.stringify(name: newName)
    @ajax
      url: "http://#{apiHost}/tags/#{oldName}/rename"
      type: "PUT"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      data: data
      error: (data, type) ->
        alert('There was a problem renaming the tag. Please try again later')

  deleteTag: (name) ->
    @ajax
      url: "http://#{apiHost}/tags/#{name}"
      type: "DELETE"
      contentType: 'application/json'
      dataType: 'text'
      headers:
        authorization: @authId
      error: (data, type) ->
        alert('There was a problem deleting the tag. Please try again later')
