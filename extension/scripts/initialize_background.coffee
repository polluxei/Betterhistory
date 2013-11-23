errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
analyticsTracker = new BH.Trackers.AnalyticsTracker()

try
  window.syncStore = new BH.Lib.SyncStore
    chrome: chrome
    tracker: analyticsTracker

  window.persistence = new BH.Init.Persistence
    localStore: new BH.Lib.LocalStore
      chrome: chrome
      tracker: analyticsTracker
    syncStore: new BH.Lib.SyncStore
      chrome: chrome
      tracker: analyticsTracker

  omnibox = new BH.Lib.Omnibox
    chrome: chrome
    tracker: analyticsTracker
  omnibox.listen()

  window.selectionContextMenu = new BH.Lib.SelectionContextMenu
    chrome: chrome
    tracker: analyticsTracker

  window.pageContextMenu = new BH.Lib.PageContextMenu
    chrome: chrome
    tracker: analyticsTracker
  pageContextMenu.listenToTabs()

  syncStore.get 'settings', (data) ->
    settings = data.settings || {}

    if settings.searchBySelection != false
      selectionContextMenu.create()

    if settings.searchByDomain != false
      pageContextMenu.create()

  tagFeature = new BH.Init.TagFeature
    syncStore: syncStore

  tagFeature.prepopulate =>
    exampleTags = new BH.Lib.ExampleTags()
    exampleTags.load()

catch e
  errorTracker.report e
