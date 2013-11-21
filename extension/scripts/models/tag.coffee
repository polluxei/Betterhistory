class BH.Models.Tag extends Backbone.Model
  validate: (attrs, options) ->
    name = attrs.name.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

    if name.length == 0
      return "tag is empty"
    if name.match(/[\"\'\~\,\.\|\(\)\{\}\[\]\;\:\<\>\^\*\%\^]/)
      return "tag contains special characters"

  fetch: (callback = ->) ->
    persistence.tag().fetchTagSites @get('name'), (sites) =>
      persistence.tag().fetchSharedTag @get('name'), (url) =>
        @set sites: sites, url: url
        callback()

  destroy: (callback = ->) ->
    persistence.tag().removeTag @get('name'), =>
      if user.isLoggedIn()
        persistence.remote().deleteTag @get('name')
      @set sites: []
      callback()

  removeSite: (url, callback = ->) ->
    persistence.tag().removeSiteFromTag url, @get('name'), (sites) =>
      @set sites: sites
      callback()

  renameTag: (name, callback = ->) ->
    persistence.tag().renameTag @get('name'), name, =>
      if user.isLoggedIn()
        persistence.remote().renameTag @get('name'), name
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
          persistence.remote().share json,
            success: (data) =>
              persistence.tag().shareTag(@get('name'), data.url)
              callbacks.success(data)
            error: ->
              callbacks.error()
