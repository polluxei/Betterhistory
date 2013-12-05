describe "BH.Lib.PageContextMenu", ->
  beforeEach ->
    @pageContextMenu = new BH.Lib.PageContextMenu
      chrome: chrome
      tracker: contextMenuClick: jasmine.createSpy()

  describe "#create", ->
    it "creates a page context menu", ->
      @pageContextMenu.create()
      expect(chrome.contextMenus.create).toHaveBeenCalledWith
        title: "[translated visits_to_domain]"
        contexts: ["page"]
        id: 'better_history_page_context_menu'

    it "stores the menu", ->
      @pageContextMenu.create()
      expect(@pageContextMenu.menu).toBeDefined()

    it "adds an onclick listener", ->
      @pageContextMenu.create()
      expect(chrome.contextMenus.onClicked.addListener).toHaveBeenCalledWith(jasmine.any(Function))

  describe "#onClick", ->
    it "opens a tab to search by the domain", ->
      @pageContextMenu.onClick
        pageUrl: "http://code.google.com/projects"
        menuItemId: 'better_history_page_context_menu'

      expect(chrome.tabs.create).toHaveBeenCalledWith url: "chrome://history/#search/code.google.com"

    it "opens a tab to the search page when a domain can't be extracted", ->
      @pageContextMenu.onClick
        pageUrl: "invalid"
        menuItemId: 'better_history_page_context_menu'

      expect(chrome.tabs.create).toHaveBeenCalledWith url: "chrome://history/#search"

  describe "#updateTitleDomain", ->
    it "updates the title domain from the passed tab", ->
      @pageContextMenu.updateTitleDomain url: "http://code.google.com/projects"
      expect(chrome.contextMenus.update).toHaveBeenCalledWith @pageContextMenu.menu,
        title: "[translated visits_to_domain]"

    it "does not update the title domain when the domain can not be extracted", ->
      @pageContextMenu.updateTitleDomain url: "invalid"
      expect(chrome.contextMenus.update).not.toHaveBeenCalled()

  describe "#listenToTabs", ->
    it "reacts to activate change when the context menu exists", ->
      @pageContextMenu.create()
      @pageContextMenu.listenToTabs()
      chrome.tabs.onActivated.addListener.mostRecentCall.args[0](tabId: '123')
      expect(chrome.contextMenus.update).toHaveBeenCalled()

    it "does not react to selection change when the context menu does not exist", ->
      @pageContextMenu.listenToTabs()
      chrome.tabs.onActivated.addListener.mostRecentCall.args[0](tabId: '123')
      expect(chrome.contextMenus.update).not.toHaveBeenCalled()

    it "reacts to tab updates when the context menu exists", ->
      @pageContextMenu.create()
      @pageContextMenu.listenToTabs()
      chrome.tabs.onUpdated.addListener.mostRecentCall.args[0] true, true,
        selected: true
        url: "http://code.google.com/projects"

      expect(chrome.contextMenus.update).toHaveBeenCalled()

    it "does not react to tab updates when the context menu does not exists", ->
      @pageContextMenu.listenToTabs()
      chrome.tabs.onUpdated.addListener.mostRecentCall.args[0]()
      expect(chrome.contextMenus.update).not.toHaveBeenCalled()

  describe "#onTabUpdated", ->
    it "updates the title domain when the tab is selected", ->
      @pageContextMenu.onTabUpdated
        selected: true
        url: "http://code.google.com/projects"

      expect(chrome.contextMenus.update).toHaveBeenCalled()

    it "does not update the title domain when the tab is not selected", ->
      @pageContextMenu.onTabUpdated
        selected: false

      expect(chrome.contextMenus.update).not.toHaveBeenCalled()

  describe "#onTabSelectionChanged", ->
    id = 1
    it "gets the tab from the passed id", ->
      @pageContextMenu.onTabSelectionChanged id
      expect(chrome.tabs.get).toHaveBeenCalledWith id, jasmine.any(Function)

    it "updates the title domain", ->
      @pageContextMenu.onTabSelectionChanged id
      expect(chrome.contextMenus.update).toHaveBeenCalled()

  describe "#remove", ->
    beforeEach ->
      @pageContextMenu.create()

    it "removes the context menu", ->
      menu = @pageContextMenu.menu
      @pageContextMenu.remove()
      expect(chrome.contextMenus.remove).toHaveBeenCalledWith menu

    it "deletes the store menu", ->
      @pageContextMenu.remove()
      expect(@pageContextMenu.menu).not.toBeDefined()

  describe "#getDomain", ->
    it "returns the domain when matched", ->
      domain = @pageContextMenu.getDomain("http://sub.google.com/")
      expect(domain).toEqual("sub.google.com")

    it "returns the domain minus the www", ->
      domain = @pageContextMenu.getDomain("http://www.google.com/")
      expect(domain).toEqual("google.com")

    it "returns the domain with only the beginning www removed", ->
      domain = @pageContextMenu.getDomain("http://www.googlewww.com/")
      expect(domain).toEqual("googlewww.com")

    it "returns the domain for chrome links", ->
      domain = @pageContextMenu.getDomain("chrome://extensions/")
      expect(domain).toEqual("extensions")

    it "returns false if no domain can be matched", ->
      domain = @pageContextMenu.getDomain("not a url")
      expect(domain).toEqual false
