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

      persistence.tag().fetchTags (data) ->
        tags = data?.tags

        callback() if !tagInstructionsDismissed && !_.isArray(tags)
