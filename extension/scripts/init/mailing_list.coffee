class BH.Init.MailingList
  constructor: (options) ->
    @syncStore = options.syncStore

  prompt: (callback) ->
    @syncStore.get ['mailingListPromptTimer', 'mailingListPromptSeen'], (data) =>
      mailingListPromptTimer = data.mailingListPromptTimer || 5
      mailingListPromptSeen = data.mailingListPromptSeen
      unless mailingListPromptSeen?
        if mailingListPromptTimer == 1
          callback()
          @syncStore.remove 'mailingListPromptTimer'
          @syncStore.set mailingListPromptSeen: true
        else
          @syncStore.set mailingListPromptTimer: (mailingListPromptTimer - 1)
