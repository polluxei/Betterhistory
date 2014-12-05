(function() {
  var errorTracker = new BH.Lib.ErrorTracker(Honeybadger),
      analyticsTracker = new BH.Lib.AnalyticsTracker();

  load = function() {
    var browserActions = new BH.Chrome.BrowserActions({
      chrome: chrome,
      tracker: analyticsTracker
    });
    browserActions.listen();

    var omnibox = new BH.Chrome.Omnibox({
      chrome: chrome,
      tracker: analyticsTracker
    });
    omnibox.listen();

    window.selectionContextMenu = new BH.Chrome.SelectionContextMenu({
      chrome: chrome,
      tracker: analyticsTracker
    });

    window.pageContextMenu = new BH.Chrome.PageContextMenu({
      chrome: chrome,
      tracker: analyticsTracker
    });
    pageContextMenu.listenToTabs();

    new ChromeSync().get('settings', function(data) {
      var settings = data.settings || {};

      if(settings.searchBySelection !== false) {
        selectionContextMenu.create();
      }

      if(settings.searchByDomain !== false) {
        pageContextMenu.create();
      }
    });
  };

  if(BH.config.env === 'prod') {
    try {
      load();
    }
    catch(e) {
      errorTracker.report(e);
    }
  } else {
    load();
  }
})();
