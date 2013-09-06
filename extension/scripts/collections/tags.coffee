class BH.Collections.Tags extends Backbone.Collection
  model: BH.Models.Tag

  initialize: (models = {}, options = {}) ->
    throw "Persistence is not set" unless options.persistence?
    @persistence = options.persistence

  fetch: (callback = ->) ->
    @persistence.fetchTags (tags) =>
      @reset tags, persistence: @persistence
      callback()

  destroy: (callback = ->)->
    @persistence.removeAllTags(callback)
