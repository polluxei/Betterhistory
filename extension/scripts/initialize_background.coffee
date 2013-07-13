settings = if localStorage['settings']? then JSON.parse(localStorage['settings']) else {}

window.selectionContextMenu = new BH.Lib.SelectionContextMenu()

if settings.searchBySelection
  selectionContextMenu.create()

window.pageContextMenu = new BH.Lib.PageContextMenu()
pageContextMenu.listenToTabs()

if settings.searchByDomain
  pageContextMenu.create()

browserActions = new BH.Lib.BrowserActions()
browserActions.listen()
