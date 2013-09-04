class BH.Models.Tag extends Backbone.Model
  initialize: (attrs = {}, options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "LocalStore is not set" unless options.localStore?

    @chromeAPI = options.chrome
    @localStore = options.localStore

  fetch: (callback = ->) ->
    name = @get('name')
    @localStore.get name, (data) =>
      data[name] ||= []
      sites = for site in data[name]
        {title: site.title, url: site.url, datetime: site.datetime}

      @set sites: sites
      callback()

  destroy: (callback = ->) ->
    @localStore.get 'tags', (data) =>
      data.tags ||= []
      data.tags = _.without(data.tags, @get('name'))
      @localStore.set data, =>
        @localStore.remove @get('name'), ->
          callback()

  removeSite: (url, callback = ->) ->
    name = @get('name')
    @localStore.get name, (data) =>
      data[name] ||= []
      data[name] = _.reject data[name], (site) =>
        url == site.url
      @localStore.set data, =>
        @set sites: data[name]
        callback()
