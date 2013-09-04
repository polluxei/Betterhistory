class BH.Collections.Tags extends Backbone.Collection
  model: BH.Models.Tag

  initialize: (models = {}, options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "LocalStore is not set" unless options.localStore?

    @chromeAPI = options.chrome
    @localStore = options.localStore

  fetch: (callback = ->) ->
    @localStore.get 'tags', (data) =>
      tags = data.tags || []

      @localStore.get tags, (data) =>
        foundTags = []
        tags = for tag, sites of data
          {name: tag, sites: sites}

        @reset tags,
          chrome: @chromeAPI
          localStore: @localStore

        callback()

  destroy: ->
    @localStore.get 'tags', (data) =>
      tags = data.tags || []
      tags.push 'tags'

      @localStore.remove tags
