class BH.Collections.Tags extends Backbone.Collection
  model: BH.Models.Tag

  initialize: (models = {}, options = {}) ->
    @persistence = options.persistence

  fetch: (callback = ->) ->
    @persistence ||= lazyPersistence()
    @persistence.fetchTags (tags, compiledTags) =>
      @tagOrder = tags
      @reset compiledTags, persistence: @persistence
      callback()

  destroy: (callback = ->)->
    @persistence ||= lazyPersistence()
    @persistence.removeAllTags(callback)

lazyPersistence = ->
  new BH.Persistence.Tag(localStore: localStore)
