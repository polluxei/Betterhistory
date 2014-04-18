describe "BH.Chrome.SelectionContextMenu", ->
  beforeEach ->
    @selectionContextMenu = new BH.Chrome.SelectionContextMenu
      chrome: chrome
      tracker: selectionContextMenuClick: jasmine.createSpy()

  describe "#create", ->
    it "creates a selection context menu", ->
      @selectionContextMenu.create()
      expect(chrome.contextMenus.create).toHaveBeenCalledWith
        title: "[translated search_in_history]"
        contexts: [ "selection" ]
        id: 'better_history_selection_context_menu'

    it "stores the menu", ->
      @selectionContextMenu.create()
      expect(@selectionContextMenu.menu).toBeDefined()

  describe "#onClick", ->
    it "opens a tab to search by the selection", ->
      @selectionContextMenu.onClick
        menuItemId: 'better_history_selection_context_menu'
        selectionText: 'text here'
      expect(chrome.tabs.create).toHaveBeenCalledWith url:'chrome://history/#search/text here'

  describe "#remove", ->
    beforeEach ->
      @selectionContextMenu.create()

    it "removes the context menu", ->
      menu = @selectionContextMenu.menu
      @selectionContextMenu.remove()
      expect(chrome.contextMenus.remove).toHaveBeenCalledWith menu

    it "deletes the stored reference", ->
      @selectionContextMenu.remove()
      expect(@selectionContextMenu.menu).not.toBeDefined()

