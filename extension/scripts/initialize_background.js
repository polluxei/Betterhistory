(function() {
  window.env = '$ENV$';

  var errorTracker = new BH.Trackers.ErrorTracker(Honeybadger),
      analyticsTracker = new BH.Trackers.AnalyticsTracker();

  load = function() {
    syncStore = new BH.Chrome.SyncStore({
      chrome: chrome,
      tracker: analyticsTracker
    });

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

    var selectionContextMenu = new BH.Chrome.SelectionContextMenu({
      chrome: chrome,
      tracker: analyticsTracker
    });

    var pageContextMenu = new BH.Chrome.PageContextMenu({
      chrome: chrome,
      tracker: analyticsTracker
    });
    pageContextMenu.listenToTabs();

    syncStore.get('settings', function(data) {
      var settings = data.settings || {};

      if(settings.searchBySelection !== false) {
        selectionContextMenu.create();
      }

      if(settings.searchByDomain !== false) {
        pageContextMenu.create();
      }
    });
  };

  if(env === 'prod') {
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
