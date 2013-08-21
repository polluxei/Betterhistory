window.track = new BH.Lib.Track(_gaq)

window.syncStore = new BH.Lib.SyncStore
  chrome: chrome
  tracker: track

browserActions = new BH.Lib.BrowserActions
  chrome: chrome
  tracker: track
browserActions.listen()

omnibox = new BH.Lib.Omnibox
  chrome: chrome
  tracker: track
omnibox.listen()

window.selectionContextMenu = new BH.Lib.SelectionContextMenu
  chrome: chrome
  tracker: track

window.pageContextMenu = new BH.Lib.PageContextMenu
  chrome: chrome
  tracker: track
pageContextMenu.listenToTabs()

syncStore.get 'settings', (data) ->
  settings = data.settings || {}

  if settings.searchBySelection != false
    selectionContextMenu.create()

  if settings.searchByDomain != false
    pageContextMenu.create()
