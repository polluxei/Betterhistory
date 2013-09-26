class BH.Lib.SelectionContextMenu extends BH.Base
  @include BH.Modules.I18n
  @include BH.Modules.Url

  constructor: (options = {})->
    throw "Chrome API not set" unless options.chrome?
    throw "Tracker not set" unless options.tracker?

    @chromeAPI = options.chrome
    @tracker = options.tracker
    @id = 'better_history_selection_context_menu'

  create: ->
    if @chromeAPI.contextMenus?.create?
      @menu = @chromeAPI.contextMenus.create
        title: @t('search_in_history')
        contexts: ['selection']
        id: @id

      @chromeAPI.contextMenus.onClicked.addListener (data) =>
        @onClick(data)

  onClick: (data) ->
    if data.menuItemId == @id
      urlOptions = absolute: true
      url = @urlFor('search', data.selectionText, urlOptions)

      @tracker.selectionContextMenuClick()

      @chromeAPI.tabs.create
        url: url

  remove: ->
    @chromeAPI.contextMenus.remove(@menu)
    delete(@menu)
