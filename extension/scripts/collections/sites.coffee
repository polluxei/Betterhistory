class BH.Collections.Sites extends Backbone.Collection
  model: BH.Models.Site

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
          datetime: model.get('datetime') || new Date().getTime()

    persistence.tag().addSitesToTag sites, tag, (operations) =>
      if user.isLoggedIn()
        translator = new BH.Lib.SyncingTranslator()
        translator.addImageToSites @toJSON(), (compiledSites) ->
          persistence.remote().updateSites compiledSites
      chrome.runtime.sendMessage({action: 'calculate hash'})
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

    persistence.tag().removeSitesFromTag sites, tag, =>
      if user.isLoggedIn()
        translator = new BH.Lib.SyncingTranslator()
        translator.addImageToSites @toJSON(), (compiledSites) ->
          persistence.remote().updateSites compiledSites
      chrome.runtime.sendMessage({action: 'calculate hash'})
      @trigger 'change:allTags'
      callback()
