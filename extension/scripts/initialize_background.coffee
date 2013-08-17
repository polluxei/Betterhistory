window.track = new BH.Lib.Track(_gaq)

browserActions = new BH.Lib.BrowserActions()
browserActions.listen()

omnibox = new BH.Lib.Omnibox()
omnibox.listen()

window.selectionContextMenu = new BH.Lib.SelectionContextMenu()

window.pageContextMenu = new BH.Lib.PageContextMenu()
pageContextMenu.listenToTabs()

BH.Lib.SyncStore.get 'settings', (data) ->
  settings = data.settings || {}

  if settings.searchBySelection != false
    selectionContextMenu.create()

  if settings.searchByDomain != false
    pageContextMenu.create()
