error = (data, type) ->
  tagState.set(readOnly: true)

class BH.Persistence.Remote
  constructor: (@authId, @ajax) ->

  host: ->
    "http://#{apiHost}"

  updateAuthId: (authId) ->
    @authId = authId

  performRequest: (options = {}) ->
    return error() unless navigator.onLine
    tagState.set(syncing: true) unless options.disableSyncingFeedback

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
              authErrorModal = new BH.Modals.AuthErrorModal()
              authErrorModal.open()
        else
          error(data, type)
          options.error(data, type) if options.error?
      success: (data) ->
        tagState.set(readOnly: false)
        options.success(data) if options.success?
      complete: =>
        setTimeout =>
          tagState.set(syncing: false)
        , 1000

        options.complete() if options.complete?

    if options.authorization
      config.headers = authorization: @authId

    config.data = JSON.stringify(options.data) if options.data?

    @ajax config

  sitesHash: (callback) ->
    @performRequest
      path: '/user/sites/hash'
      type: 'GET'
      dataType: 'json'
      authorization: true
      disableSyncingFeedback: true
      success: callback

  share: (tagData, callbacks) ->
    params =
      path: '/share'
      data: tagData
      type: 'POST'
      dataType: 'json'
      success: callbacks.success
      error: callbacks.error
      disableSyncingFeedback: true
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
      path: "/user/tags/#{oldName.replace(/\s+/g, '-')}/rename"
      type: 'PUT'
      data: {name: newName}
      authorization: true

  deleteTag: (name) ->
    @performRequest
      path: "/user/tags/#{name.replace(/\s+/g, '-')}"
      type: 'DELETE'
      authorization: true

  deleteSites: (callback = ->) ->
    @performRequest
      path: '/user/sites'
      type: 'DELETE'
      success: callback
      authorization: true
