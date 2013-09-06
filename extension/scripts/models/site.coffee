class BH.Models.Site extends Backbone.Model
  initialize: ({}, options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "Persistence is not set" unless options.persistence?

    @chromeAPI = options.chrome
    @persistence = options.persistence

  fetch: (callback = ->) ->
    @chromeAPI.tabs.query active: true, (tabs) =>
      tab = tabs[0] || {}

      @persistence.fetchSiteTags tab.url, (tags) =>
        @set
          title: tab.title
          url: tab.url
          tags: tags
          domain: extractDomain(tab.url)
        callback()

  addTag: (tag) ->
    tag = tag.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

    return false if @get('tags').indexOf(tag) != -1
    return false if tag.length == 0

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    newTags.push tag
    @set tags: newTags

    site =
      url: @get('url')
      title: @get('title')

    @persistence.addSiteToTag site, tag

  removeTag: (tag) ->
    return false if @get('tags').indexOf(tag) == -1

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    @set tags: _.without(newTags, tag)

    @persistence.removeSiteFromTag @get('url'), tag

extractDomain = (url) ->
  match = url.match(/\/\/(.*?)\//)
  domain = if match == null then null else match[1]
  domain.replace('www.', '')
