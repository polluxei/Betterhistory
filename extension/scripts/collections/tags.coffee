class BH.Collections.Tags extends Backbone.Collection
  model: BH.Models.Tag

  initialize: ->

  fetch: (callback = ->) ->
    persistence.tag().fetchTags (tags, compiledTags) =>
      @tagOrder = tags
      @reset compiledTags
      callback()

  destroy: (callback = ->)->
    persistence.tag().removeAllTags =>
      chrome.runtime.sendMessage({action: 'calculate hash'})
      callback()
      @trigger 'sync', operation: 'destroy'

  sync: (options) ->
    switch options.operations
      when 'destroy'
        persistence.remote().deleteSites()
