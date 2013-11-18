class BH.Models.Site extends Backbone.Model
  initialize: (attrs = {}, options = {}) ->
    @chromeAPI = options.chrome
    @persistence = options.persistence
    @syncPersistence = options.syncPersistence

  fetch: (callback = ->) ->
    @persistence ||= lazyPersistence()
    @persistence.fetchSiteTags @get('url'), (tags) =>
      @set tags: tags
      @trigger 'reset:tags'
      callback()

  tags: ->
    @get('tags')

  addTag: (tag, callback = ->) ->
    @persistence ||= lazyPersistence()

    tag = tag.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

    if tag.length == 0 || tag.match(/[\"\'\~\,\.\|\(\)\{\}\[\]\;\:\<\>\^\*\%\^]/) || @get('tags').indexOf(tag) != -1
      callback(false, null)
      return

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    newTags.push tag
    @set tags: newTags

    site =
      url: @get('url')
      title: @get('title')

    @persistence.addSiteToTag site, tag, (operations) =>
      if user.isLoggedIn()
        @syncPersistence ||= lazySyncPersistence()
        @syncPersistence.updateSite @toSync()
      callback(true, operations)

  removeTag: (tag) ->
    @persistence ||= lazyPersistence()

    return false if @get('tags').indexOf(tag) == -1

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    @set tags: _.without(newTags, tag)

    @persistence.removeSiteFromTag @get('url'), tag

    if user.isLoggedIn()
      @syncPersistence ||= lazySyncPersistence()
      @syncPersistence.updateSite @toSync()

  toSync: ->
    url: @get('url')
    title: @get('title')
    datetime: @get('datetime')
    tags: @get('tags').join(' ')

lazyPersistence = ->
  new BH.Persistence.Tag(localStore: localStore)

lazySyncPersistence = ->
  new BH.Persistence.Sync(user.get('authId'), $.ajax)
