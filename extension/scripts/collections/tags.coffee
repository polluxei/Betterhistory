class BH.Collections.Tags extends Backbone.Collection
  model: BH.Models.Tag

  fetch: (callback = ->) ->
    persistence.tag().fetchTags (tags, compiledTags) =>
      @tagOrder = tags
      @reset compiledTags
      callback()

  destroy: (callback = ->)->
    persistence.tag().removeAllTags(callback)
