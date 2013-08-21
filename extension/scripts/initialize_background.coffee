tracker = new BH.Lib.Tracker(_gaq)

window.syncStore = new BH.Lib.SyncStore
  chrome: chrome
  tracker: tracker

browserActions = new BH.Lib.BrowserActions
  chrome: chrome
  tracker: tracker
browserActions.listen()

omnibox = new BH.Lib.Omnibox
  chrome: chrome
  tracker: tracker
omnibox.listen()

window.selectionContextMenu = new BH.Lib.SelectionContextMenu
  chrome: chrome
  tracker: tracker

window.pageContextMenu = new BH.Lib.PageContextMenu
  chrome: chrome
  tracker: tracker
pageContextMenu.listenToTabs()

syncStore.get 'settings', (data) ->
  settings = data.settings || {}

  if settings.searchBySelection != false
    selectionContextMenu.create()

  if settings.searchByDomain != false
    pageContextMenu.create()
