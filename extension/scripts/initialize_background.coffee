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

  chrome.runtime.onInstalled.addListener ->
    ensureDatetimeOnTaggedSites = new BH.Migrations.EnsureDatetimeOnTaggedSites
      analyticsTracker: analyticsTracker
    ensureDatetimeOnTaggedSites.run()


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

  tagFeature = new BH.Init.TagFeature
    syncStore: syncStore

  tagFeature.prepopulate =>
    exampleTags = new BH.Lib.ExampleTags()
    exampleTags.load()

  chrome.runtime.onMessage.addListener (message) ->
    if message.action == 'calculate hash'
      persistence.tag().fetchTags (tags, compiledTags) =>
        if tags.length > 0
          syncingTranslator = new BH.Lib.SyncingTranslator()
          syncingTranslator.forServer compiledTags, (sites) =>
            sitesHasher = new BH.Lib.SitesHasher(CryptoJS.SHA1)
            sitesHash = sitesHasher.generate(sites).toString()
            persistence.tag().setSitesHash sitesHash
          , skipImages: true
        else
          persistence.tag().setSitesHash ''

if env == 'prod'
  try
    load()
  catch e
    errorTracker.report e
else
  load()
