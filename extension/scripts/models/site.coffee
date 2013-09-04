class BH.Models.Site extends Backbone.Model
  initialize: ({}, options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "LocalStore is not set" unless options.localStore?

    @chromeAPI = options.chrome
    @localStore = options.localStore

  fetch: (callback = ->) ->
    @chromeAPI.tabs.query active: true, (tabs) =>
      tab = tabs[0] || {}

      setAttributes = (tab, tags = []) =>

      @localStore.get 'tags', (data) =>
        tags = data.tags || []

        @localStore.get tags, (data) =>
          foundTags = []
          for tag, sites of data
            for site in sites
              foundTags.push tag if site.url == tab.url

          match = tab.url.match(/\/\/(.*?)\//)
          domain = if match == null then null else match[1]
          domain = domain.replace('www.', '')

          @set
            title: tab.title
            url: tab.url
            tags: foundTags
            domain: domain

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
      data = tags: [] unless data.tags?
      data.tags.push tag
      @localStore.set data

    @localStore.get tag, (data) =>
      data[tag] ||= []
      data[tag].push
        url: @get('url')
        title: @get('title')
        datetime: new Date().getTime()
      @localStore.set data

  removeTag: (tag) ->
    return false if @get('tags').indexOf(tag) == -1

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    @set tags: _.without(newTags, tag)

    @localStore.get "tags", (data) =>
      data = tags: [] unless data.tags?
      data.tags = _.without(data.tags, tag)
      @localStore.set data

    @localStore.get tag, (data) =>
      url = @get('url')
      data[tag] = _.reject data[tag], (site) =>
        url == site.url
      @localStore.set data
