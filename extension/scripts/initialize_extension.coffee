window.apiHost = '$API_HOST$'
window.siteHost = '$SITE_HOST$'

window.errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
window.analyticsTracker = new BH.Trackers.AnalyticsTracker(_gaq)

window.BH.user = new Backbone.Model()

try
  analyticsTracker.historyOpen()

  window.syncStore = new BH.Lib.SyncStore
    chrome: chrome
    tracker: analyticsTracker

  window.localStore = new BH.Lib.LocalStore
    chrome: chrome
    tracker: analyticsTracker

  syncStore.get 'authId', (data = {}) ->
    $('body').addClass 'logged_in' if data.authId?

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
            tracker: analyticsTracker

          Backbone.history.start()

  mailingList = new BH.Init.MailingList(syncStore: syncStore)
  mailingList.prompt ->
    new BH.Views.MailingListView().open()
    analyticsTracker.mailingListPrompt()

  tagFeature = new BH.Init.TagFeature(syncStore: syncStore)
  tagFeature.announce ->
    $('body').addClass('new_tags')

catch e
  errorTracker.report e
