window.apiHost = '$API_HOST$'
window.siteHost = '$SITE_HOST$'
window.env = '$ENV$'

if env == 'prod'
  window.errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)

window.analyticsTracker = new BH.Trackers.AnalyticsTracker(_gaq)

load = ->
  BH.lang = chrome.i18n?.getUILanguage?() || 'en'

  analyticsTracker.historyOpen()

  window.syncStore = new BH.Chrome.SyncStore
    chrome: chrome
    tracker: analyticsTracker

  syncStore.get 'authId', (data = {}) ->
    $('body').addClass 'logged_in' if data.authId?

  new BH.Lib.DateI18n().configure()

  window.settings = new BH.Models.Settings({})

  window.persistence = new BH.Init.Persistence
    localStore: new BH.Chrome.LocalStore
      chrome: chrome
      tracker: analyticsTracker
    syncStore: new BH.Chrome.SyncStore
      chrome: chrome
      tracker: analyticsTracker
    ajax: $.ajax

  settings.fetch
    success: =>
      window.router = new BH.Router
        settings: settings
        tracker: analyticsTracker
      Backbone.history.start()

      persistence.tag().fetchTags (tags) ->
        defaultTags = ['games', 'places to travel', 'clothing', 'recipes', 'friends', 'funny videos', 'world news', 'productivity']
        if tags.length > 0
          if _.difference(tags, defaultTags).length != 0
            $('.tags_menu').show() if tags.length > 0

  mailingList = new BH.Init.MailingList(syncStore: syncStore)
  mailingList.prompt ->
    new BH.Modals.MailingListModal().open()
    analyticsTracker.mailingListPrompt()

if env == 'prod'
  try
    load()
  catch e
    errorTracker.report e
else
  load()
