class BH.Persistence.Tag
  constructor: (options) ->
    throw "Localstore is not set" unless options.localStore?
    @localStore = options.localStore

  fetchTags: (callback) ->
    @localStore.get 'tags', (data) =>
      tags = data.tags || []

      @localStore.get tags, (data) =>
        foundTags = []
        tags = for tag, sites of data
          {name: tag, sites: sites}
        callback(tags)

  fetchTagSites: (name, callback = ->) ->
    @localStore.get name, (data) =>
      data[name] ||= []
      sites = for site in data[name]
        {
          title: site.title
          url: site.url
          datetime: site.datetime
        }
      callback(sites)

  fetchSiteTags: (url, callback = ->) ->
    @localStore.get 'tags', (data) =>
      tags = data.tags || []

      @localStore.get tags, (data) =>
        foundTags = []
        for tag, sites of data
          for site in sites
            foundTags.push tag if site.url == url

        callback(foundTags)

  addSiteToTag: (site, tag) ->
    @localStore.get "tags", (data) =>
      data = tags: [] unless data.tags?
      if data.tags.indexOf(tag) == -1
        data.tags.push tag
      @localStore.set data

    @localStore.get tag, (data) =>
      data[tag] ||= []
      site.datetime = new Date().getTime()
      data[tag].push site
      @localStore.set data

  removeSiteFromTag: (url, tag, callback = ->) ->
    @localStore.get tag, (data) =>
      data[tag] ||= []
      data[tag] = _.reject data[tag], (site) =>
        url == site.url
      @localStore.set data, =>
        callback(data[tag])

  removeTag: (tag, callback = ->) ->
    @localStore.get 'tags', (data) =>
      data.tags ||= []
      data.tags = _.without(data.tags, tag)
      @localStore.set data, =>
        @localStore.remove tag, ->
          callback()

  removeAllTags: (callback = ->) ->
    @localStore.get 'tags', (data) =>
      tags = data.tags || []
      tags.push 'tags'

      @localStore.remove tags, ->
        callback()

  renameTag: (oldTag, newTag, callback = ->) ->
    @localStore.get 'tags', (data) =>
      data.tags ||= []
      index = data.tags.indexOf(oldTag)
      data.tags[index] = newTag
      @localStore.set data, =>
        @localStore.get oldTag, (data) =>
          sites = data[oldTag]
          @localStore.remove oldTag, =>
            data = {}
            data[newTag] = sites
            @localStore.set data, ->
              callback()
