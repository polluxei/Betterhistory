window.apiHost = '$API_HOST$'
window.siteHost = '$SITE_HOST$'
window.env = '$ENV$'

errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
analyticsTracker = new BH.Trackers.AnalyticsTracker()

load = ->
  window.syncStore = new BH.Chrome.SyncStore
    chrome: chrome
    tracker: analyticsTracker

  window.persistence = new BH.Init.Persistence
    localStore: new BH.Chrome.LocalStore
      chrome: chrome
      tracker: analyticsTracker
    syncStore: new BH.Chrome.SyncStore
      chrome: chrome
      tracker: analyticsTracker

  browserActions = new BH.Chrome.BrowserActions
    chrome: chrome
    tracker: analyticsTracker
  browserActions.listen()

  omnibox = new BH.Chrome.Omnibox
    chrome: chrome
    tracker: analyticsTracker
  omnibox.listen()

  window.selectionContextMenu = new BH.Chrome.SelectionContextMenu
    chrome: chrome
    tracker: analyticsTracker

  window.pageContextMenu = new BH.Chrome.PageContextMenu
    chrome: chrome
    tracker: analyticsTracker
  pageContextMenu.listenToTabs()

  syncStore.get 'settings', (data) ->
    settings = data.settings || {}

    if settings.searchBySelection != false
      selectionContextMenu.create()

    if settings.searchByDomain != false
      pageContextMenu.create()

if env == 'prod'
  try
    load()
  catch e
    errorTracker.report e
else
  load()
