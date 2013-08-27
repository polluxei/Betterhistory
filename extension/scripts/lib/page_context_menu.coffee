class BH.Lib.PageContextMenu extends BH.Base
  @include BH.Modules.I18n
  @include BH.Modules.Url

  constructor: (options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "Tracker not set" unless options.tracker?

    @chromeAPI = options.chrome
    @tracker = options.tracker

    @id = 'better_history_page_context_menu'

  create: ->
    @menu = @chromeAPI.contextMenus.create
      title: @t('visits_to_domain', ['domain'])
      contexts: ['page']
      id: @id

    @chromeAPI.contextMenus.onClicked.addListener (data) =>
      @onClick(data)

  onClick: (data) ->
    if data.menuItemId == @id
      urlOptions = absolute: true
      url = if domain = @getDomain(data.pageUrl)
        @urlFor('search', @getDomain(data.pageUrl), urlOptions)
      else
        "chrome://history/#search"

      @tracker.contextMenuClick()

      @chromeAPI.tabs.create
        url: url

  updateTitleDomain: (tab) ->
    if domain = @getDomain(tab.url)
      @chromeAPI.contextMenus.update @menu,
        title: @t('visits_to_domain', [domain])

  listenToTabs: ->
    @chromeAPI.tabs.onActivated.addListener (tabInfo) =>
      @onTabSelectionChanged(tabInfo.tabId) if @menu

    @chromeAPI.tabs.onUpdated.addListener (tabId, changedInfo, tab) =>
      @onTabUpdated(tab) if @menu

  onTabSelectionChanged: (tabId) ->
    @chromeAPI.tabs.get tabId, (tab) =>
      @updateTitleDomain(tab)

  onTabUpdated: (tab) ->
    @updateTitleDomain(tab) if tab.selected

  remove: ->
    @chromeAPI.contextMenus.remove(@menu)
    delete(@menu)

  getDomain: (url) ->
    match = url.match(/\w+:\/\/(.*?)\//)
    if match? then match[1].replace('www.', '') else false

