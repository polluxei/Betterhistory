(function() {
  var SelectionContextMenu = function(options) {
    if(!options.chrome) {
      throw("Chrome API not set");
    }
    if(!options.tracker) {
      throw("Tracker not set");
    }

    this.chromeAPI = options.chrome;
    this.tracker = options.tracker;

    this.id = 'better_history_selection_context_menu';
  };

  SelectionContextMenu.prototype.create = function() {
    if(this.chromeAPI.contextMenus && this.chromeAPI.contextMenus.create) {
      this.menu = this.chromeAPI.contextMenus.create({
        title: this.chromeAPI.i18n.getMessage('search_in_history'),
        contexts: ['selection'],
        id: this.id
      });

      var _this = this;
      this.chromeAPI.contextMenus.onClicked.addListener(function(data) {
        _this.onClick(data);
      });
    }
  };

  SelectionContextMenu.prototype.onClick = function(data) {
    if(data.menuItemId === this.id) {
      this.tracker.selectionContextMenuClick();
      this.chromeAPI.tabs.create({
        url: "chrome://history/#search/" + data.selectionText
      });
    }
  };

  SelectionContextMenu.prototype.remove = function() {
    this.chromeAPI.contextMenus.remove(this.menu);
    delete(this.menu);
  };

  BH.Chrome.SelectionContextMenu = SelectionContextMenu;
})();
