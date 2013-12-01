error = (data, type) ->
  alert('There was a problem syncing your tags. Please try again later')

class BH.Persistence.Remote
  constructor: (@authId, @ajax, @state) ->

  host: ->
    "http://#{apiHost}"

  updateAuthId: (authId) ->
    @authId = authId

  performRequest: (options = {}) ->
    @state.set(syncing: true)

    config =
      url: @host() + options.path
      type: options.type
      contentType: 'application/json'
      dataType: options.dataType || 'text'
      error: (data, type) ->
        if data.status == 403
          user.logout()
          chrome.identity.getAuthToken (token) ->
            chrome.identity.removeCachedAuthToken token: token, ->
              authErrorView = new BH.Views.AuthErrorView()
              authErrorView.open()
        else
          error(data, type)
          options.error(data, type) if options.error?
      success: (data) ->
        options.success(data) if options.success?
      complete: =>
        setTimeout =>
          @state.set(syncing: false)
        , 1000

        options.complete() if options.complete?

    if options.authorization
      config.headers = authorization: @authId

    config.data = JSON.stringify(options.data) if options.data?

    @ajax config

  share: (tagData, callbacks) ->
    params =
      path: '/share'
      data: tagData
      type: 'POST'
      dataType: 'json'
      success: callbacks.success
      error: callbacks.error
      authorization: false

    if user.isLoggedIn()
      params.path = '/user/share'
      params.authorization = true

    @performRequest params

  updateSite: (site) ->
    @performRequest
      path: '/user/site'
      type: 'POST'
      data: site
      authorization: true

  updateSites: (sites, callback = ->) ->
    @performRequest
      path: '/user/sites'
      type: 'POST'
      data: sites
      success: callback
      authorization: true

  getSites: (callback) ->
    @performRequest
      path: '/user/sites'
      type: 'GET'
      dataType: 'json'
      success: callback
      authorization: true

  renameTag: (oldName, newName) ->
    @performRequest
      path: "/user/tags/#{oldName}/rename"
      type: 'PUT'
      data: {name: newName}
      authorization: true

  deleteTag: (name) ->
    @performRequest
      path: "/user/tags/#{name}"
      type: 'DELETE'
      authorization: true

  deleteSites: (callback = ->) ->
    @performRequest
      path: '/user/sites'
      type: 'DELETE'
      success: callback
      authorization: true
