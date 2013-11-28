class BH.Models.Site extends Backbone.Model
  initialize: (attrs = {}, options = {}) ->
    @chromeAPI = options.chrome

  fetch: (callback = ->) ->
    persistence.tag().fetchSiteTags @get('url'), (tags) =>
      @set tags: tags
      @trigger 'reset:tags'
      callback()

  tags: ->
    @get('tags')

  addTag: (tag, callback = ->) ->
    tag = tag.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

    if tag.length == 0 || tag.match(/[\"\'\~\,\.\|\(\)\{\}\[\]\;\:\<\>\^\*\%\^]/) || @get('tags').indexOf(tag) != -1
      callback(false, null)
      return

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    newTags.push tag
    @set
      tags: newTags
      datetime: new Date().getTime()

    site =
      url: @get('url')
      title: @get('title')
      datetime: @get('datetime')

    persistence.tag().addSiteToTag site, tag, (operations) =>
      if user.isLoggedIn()
        BH.Lib.ImageData.base64 "chrome://favicon/#{site.url}", (data) =>
          persistence.remote().updateSite
            url: @get('url')
            title: @get('title')
            datetime: @get('datetime')
            tags: @get('tags')
            image: data
      callback(true, operations)

  removeTag: (tag) ->
    return false if @get('tags').indexOf(tag) == -1

    # generate a new array to ensure a change event fires
    newTags = _.clone(@get('tags'))
    @set
      tags: _.without(newTags, tag)
      datetime: new Date().getTime()

    persistence.tag().removeSiteFromTag @get('url'), tag

    if user.isLoggedIn()
      BH.Lib.ImageData.base64 "chrome://favicon/#{site.url}", (data) =>
        persistence.remote().updateSite
          url: @get('url')
          title: @get('title')
          datetime: @get('datetime')
          tags: @get('tags')
          image: data
