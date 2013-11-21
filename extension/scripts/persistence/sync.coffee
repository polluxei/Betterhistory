error = (data, type) ->
  alert('There was a problem syncing your tags. Please try again later')

class BH.Persistence.Sync
  constructor: (@authId, @ajax, @state) ->

  host: ->
    "http://#{apiHost}"

  performRequest: (options = {}) ->
    @state.set(syncing: true)

    config =
      url: @host() + options.path
      type: options.type
      contentType: 'application/json'
      dataType: options.dataType || 'text'
      headers:
        authorization: @authId
      error: (data, type) ->
        error(data, type)
        options.error(data, type) if options.error?
      success: (data) ->
        options.success(data) if options.success?
      complete: =>
        setTimeout =>
          @state.set(syncing: false)
        , 1000

        options.complete() if options.complete?

    config.data = JSON.stringify(options.data) if options.data?

    @ajax config

  updateSite: (site) ->
    @performRequest
      path: '/user/site'
      type: 'POST'
      data: site

  updateSites: (sites, callback = ->) ->
    @performRequest
      path: '/user/sites'
      type: 'POST'
      data: sites
      success: callback

  getSites: (callback) ->
    @performRequest
      path: '/user/sites'
      type: 'GET'
      dataType: 'json'
      success: callback

  renameTag: (oldName, newName) ->
    @performRequest
      path: "/user/tags/#{oldName}/rename"
      type: 'PUT'
      data: {name: newName}

  deleteTag: (name) ->
    @performRequest
      path: "/user/tags/#{name}"
      type: 'DELETE'

  deleteSites: (callback = ->) ->
    @performRequest
      path: '/user/sites'
      type: 'DELETE'
      success: callback
