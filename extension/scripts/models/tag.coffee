class BH.Models.Tag extends Backbone.Model
  initialize: (attrs = {}, options = {}) ->
    @persistence = options.persistence
    @syncPersistence = options.syncPersistence

  validate: (attrs, options) ->
    name = attrs.name.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

    if name.length == 0
      return "tag is empty"
    if name.match(/[\"\'\~\,\.\|\(\)\{\}\[\]\;\:\<\>\^\*\%\^]/)
      return "tag contains special characters"

  fetch: (callback = ->) ->
    @persistence ||= lazyPersistence()
    @persistence.fetchTagSites @get('name'), (sites) =>
      @persistence.fetchSharedTag @get('name'), (url) =>
        @set sites: sites, url: url
        callback()

  destroy: (callback = ->) ->
    @persistence ||= lazyPersistence()
    @persistence.removeTag @get('name'), =>
      if user.isLoggedIn()
        @syncPersistence ||= lazySyncPersistence()
        @syncPersistence.deleteTag @get('name')
      @set sites: []
      callback()

  removeSite: (url, callback = ->) ->
    @persistence ||= lazyPersistence()
    @persistence.removeSiteFromTag url, @get('name'), (sites) =>
      @set sites: sites
      callback()

  renameTag: (name, callback = ->) ->
    @persistence ||= lazyPersistence()
    @persistence.renameTag @get('name'), name, =>
      if user.isLoggedIn()
        @syncPersistence ||= lazySyncPersistence()
        @syncPersistence.renameTag @get('name'), name
      @set name: name
      callback()

  share: (callbacks) ->
    index = 1
    json = @toJSON()

    _.each json.sites, (site, i) =>
      BH.Lib.ImageData.base64 "chrome://favicon/#{site.url}", (data) =>
        json.sites[i].image = data

        if index != json.sites.length
          index++
        else
          lazyPersistenceShare().send json,
            success: (data) =>
              @persistence.shareTag(@get('name'), data.url)
              callbacks.success(data)
            error: ->
              callbacks.error()

lazyPersistence = ->
  new BH.Persistence.Tag(localStore: localStore)

lazyPersistenceShare = ->
  new BH.Persistence.Share()

lazySyncPersistence = ->
  new BH.Persistence.Sync(user.get('authId'), $.ajax)
