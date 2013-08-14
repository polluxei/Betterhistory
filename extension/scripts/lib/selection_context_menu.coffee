class BH.Lib.SelectionContextMenu extends BH.Base
  @include BH.Modules.I18n
  @include BH.Modules.Url

  constructor: ->
    @chromeAPI = chrome
    @id = 'better_history_selection_context_menu'

  create: ->
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

      track.selectionContextMenuClick()

      @chromeAPI.tabs.create
        url: url

  remove: ->
    @chromeAPI.contextMenus.remove(@menu)
    delete(@menu)
