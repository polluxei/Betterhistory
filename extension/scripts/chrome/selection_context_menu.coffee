class BH.Chrome.SelectionContextMenu
  constructor: (options = {})->
    throw "Chrome API not set" unless options.chrome?
    throw "Tracker not set" unless options.tracker?

    @chromeAPI = options.chrome
    @tracker = options.tracker
    @id = 'better_history_selection_context_menu'

  create: ->
    if @chromeAPI.contextMenus?.create?
      @menu = @chromeAPI.contextMenus.create
        title: chrome.i18n.getMessage('search_in_history')
        contexts: ['selection']
        id: @id

      @chromeAPI.contextMenus.onClicked.addListener (data) =>
        @onClick(data)

  onClick: (data) ->
    if data.menuItemId == @id
      @tracker.selectionContextMenuClick()
      @chromeAPI.tabs.create
        url: "chrome://history/#search/#{data.selectionText}"

  remove: ->
    @chromeAPI.contextMenus.remove(@menu)
    delete(@menu)
