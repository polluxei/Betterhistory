window.track = new BH.Lib.Track(_gaq)

settings = if localStorage['settings']? then JSON.parse(localStorage['settings']) else {}

window.selectionContextMenu = new BH.Lib.SelectionContextMenu()

if settings.searchBySelection != false
  selectionContextMenu.create()

window.pageContextMenu = new BH.Lib.PageContextMenu()
pageContextMenu.listenToTabs()

if settings.searchByDomain != false
  pageContextMenu.create()

browserActions = new BH.Lib.BrowserActions()
browserActions.listen()

omnibox = new BH.Lib.Omnibox()
omnibox.listen()
