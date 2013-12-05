class BH.Init.TagFeature
  constructor: (options) ->
    @syncStore = options.syncStore

  announce: (callback = ->) ->
    @syncStore.get 'tagInstructionsDismissed', (data) ->
      tagInstructionsDismissed = data.tagInstructionsDismissed || false
      callback() unless tagInstructionsDismissed

  prepopulate: (callback) ->
    @syncStore.get 'tagInstructionsDismissed', (data) =>
      tagInstructionsDismissed = data.tagInstructionsDismissed || false

      persistence.tag().fetchTags (tags) ->
        callback() if !tagInstructionsDismissed && tags.length == 0
