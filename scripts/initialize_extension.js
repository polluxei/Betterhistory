(function() {
  if(BH.config.env === 'prod') {
    window.errorTracker = new BH.Lib.ErrorTracker(Honeybadger);
  }

  window.analyticsTracker = new BH.Lib.AnalyticsTracker();

  var load = function() {
    Historian.setWorkerPath('bower_components/chrome-historian/src/workers/');
    if(chrome && chrome.i18n && chrome.i18n.getUILanguage) {
      BH.lang = chrome.i18n.getUILanguage();
    }

    window.syncStore = new BH.Chrome.SyncStore({
      chrome: chrome,
      tracker: analyticsTracker
    });

    analyticsTracker.historyOpen();

    Settings = Backbone.Model.extend({
      defaults: {
        searchBySelection: true,
        searchByDomain: true
      }
    });
    var settings = new Settings();

    window.router = new BH.Router({
      settings: settings,
      tracker: analyticsTracker
    });
    Backbone.history.start();

    var mailingList = new BH.Init.MailingList({syncStore: syncStore});
    mailingList.prompt(function() {
      new BH.Modals.MailingListModal().open();
      analyticsTracker.mailingListPrompt();
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
