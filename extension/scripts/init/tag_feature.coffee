class BH.Init.TagFeature
  constructor: (options) ->
    @syncStore = options.syncStore
    @localStore = options.localStore

  announce: (callback = ->) ->
    @syncStore.get 'tagInstructionsDismissed', (data) ->
      tagInstructionsDismissed = data.tagInstructionsDismissed || false
      callback() unless tagInstructionsDismissed

  prepopulate: (callback) ->
    @syncStore.get 'tagInstructionsDismissed', (data) =>
      tagInstructionsDismissed = data.tagInstructionsDismissed || false

      @localStore.get 'tags', (data) ->
        tags = data?.tags

        callback() if !tagInstructionsDismissed && !_.isArray(tags)
