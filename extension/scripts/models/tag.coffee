class BH.Models.Tag extends Backbone.Model
  initialize: (attrs = {}, options = {}) ->
    @persistence = options.persistence

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
      @set name: name
      callback()

  share: (callbacks) ->
    lazyPersistenceShare().send @toJSON(),
      success: (data) =>
        @persistence.shareTag(@get('name'), data.url)
        callbacks.success(data)
      error: ->
        callbacks.error()

lazyPersistence = ->
  new BH.Persistence.Tag(localStore: localStore)

lazyPersistenceShare = ->
  new BH.Persistence.Share()
