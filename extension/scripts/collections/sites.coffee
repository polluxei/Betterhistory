class BH.Collections.Sites extends Backbone.Collection
  model: BH.Models.Site

  initialize: (attrs = {}, options) ->
    throw "Persistence not set" unless options.persistence?

    @persistence = options.persistence

  fetch: ->
    index = 1
    callback = =>
      if index == @length
        @trigger 'reset:allTags'
      else
        index++

    @each (model) ->
      model.fetch callback

  sharedTags: ->
    _.intersection.apply(@, @pluck 'tags')

  tags: ->
    @sharedTags()

  addTag: (tag, callback = ->) ->
    tag = tag.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

    if tag.length == 0 || tag.match /[\"\'\~\,\.\|\(\)\{\}\[\]\;\:\<\>\^\*\%\^]/
      callback(false, null)
      return

    sites = []
    @each (model) ->
      if model.get('tags').indexOf(tag) == -1
        # generate a new array to ensure a change event fires
        newTags = _.clone(model.get('tags'))
        newTags.push tag
        model.set tags: newTags

        sites.push
          url: model.get('url')
          title: model.get('title')

    @persistence.addSitesToTag sites, tag, (operations) =>
      @trigger 'change:allTags'
      callback(true, operations)

  removeTag: (tag, callback = ->) ->
    tag = tag.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
    return false if tag.length == 0

    sites = []
    @each (model) ->
      if model.get('tags').indexOf(tag) != -1
        # generate a new array to ensure a change event fires
        newTags = _.clone(model.get('tags'))
        model.set tags: _.without(newTags, tag)
        sites.push model.get('url')

    @persistence.removeSitesFromTag sites, tag, =>
      @trigger 'change:allTags'
      callback()
