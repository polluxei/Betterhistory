class BH.Models.Site extends Backbone.Model
  initialize: ({}, options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "LocalStore is not set" unless options.localStore?

    @chromeAPI = options.chrome
    @localStore = options.localStore

  fetch: (callback = ->) ->
    @chromeAPI.tabs.query active: true, (tabs) =>
      tab = tabs[0]
      @localStore.get 'tags', (data) =>
        tags = []
        for tag, sites of data.tags
          for site in sites
            tags.push tag if site.url == tab.url

        match = tab.url.match(/\/\/(.*?)\//)
        domain = if match == null then null else match[1]
        domain = domain.replace('www.', '')

        @set title: tab.title, url: tab.url, tags: tags, domain: domain
        callback()

  addTag: (tag) ->
    tag = tag.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

    return false if @get('tags').indexOf(tag) != -1
    return false if tag.length == 0

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    newTags.push tag
    @set tags: newTags

    @localStore.get "tags", (data) =>
      tags = data.tags || {}
      tags[tag] = [] unless tags[tag]?
      tags[tag].push
        url: @get('url')
        title: @get('title')
        datetime: new Date().getTime()
      @localStore.set tags: tags

  removeTag: (tag) ->
    return false if @get('tags').indexOf(tag) == -1

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    @set tags: _.without(newTags, tag)

    @localStore.get "tags", (data) =>
      url = @get('url')
      tags = data.tags
      tags[tag] = _.reject tags[tag], (site) =>
        url == site.url
      @localStore.set tags: tags
