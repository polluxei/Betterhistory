window.tracker = new BH.Lib.Tracker(_gaq)

window.onerror = (msg, url, lineNumber) ->
  tracker.error(msg, url, lineNumber)

window.syncStore = new BH.Lib.SyncStore
  chrome: chrome
  tracker: tracker

syncStore.migrate(localStorage)

new BH.Lib.DateI18n().configure()

settings = new BH.Models.Settings({})
state = new BH.Models.State({}, settings: settings)
settings.fetch
  success: =>
    state.fetch
      success: =>
        state.updateRoute()

        window.router = new BH.Router
          settings: settings
          state: state

        Backbone.history.start()

syncStore.get ['mailingListPromptTimer', 'mailingListPromptSeen'], (data) ->
  mailingListPromptTimer = data.mailingListPromptTimer || 3
  mailingListPromptSeen = data.mailingListPromptSeen
  unless mailingListPromptSeen?
    if mailingListPromptTimer == 1
      new BH.Views.MailingListView().open()
      syncStore.remove 'mailingListPromptTimer'
      syncStore.set mailingListPromptSeen: true
    else
      syncStore.set mailingListPromptTimer: (mailingListPromptTimer - 1)

