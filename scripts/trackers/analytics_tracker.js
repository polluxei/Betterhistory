(function() {
  var trackEvent = function(params) {
    params.unshift('_trackEvent');
    track(params);
  };

  var track = function(params) {
    _gaq.push(params);
  };

  AnalyticsTracker = function() {
    if(!_gaq) {
      throw("Analytics not set");
    }
    return {
      pageView: function(url) {
        // Don't track what people search for
        if(url.match(/search/)) {
          url = 'search';
        }
        track(['_trackPageview', '/' + url]);
      },

      historyOpen: function() {
        trackEvent(['History', 'Open']);
      },

      dayActivityVisitCount: function(amount) {
        trackEvent(['Activity', 'Day View', 'Visit Count', amount]);
      },

      dayActivityDownloadCount: function(amount) {
        trackEvent(['Activity', 'Day View', 'Download Count', amount]);
      },

      todayView: function() {
        trackEvent(['Today', 'Click']);
      },

      featureNotSupported: function(feature) {
        trackEvent(['Feature', 'Not Supported', feature]);
      },

      visitDeletion: function() {
        trackEvent(['Visit', 'Delete']);
      },

      downloadDeletion: function() {
        trackEvent(['Download', 'Delete']);
      },

      hourDeletion: function() {
        trackEvent(['Day Hour', 'Delete']);
      },

      searchResultDeletion: function() {
        trackEvent(['Searched Visit', 'Delete']);
      },

      searchResultsDeletion: function() {
        trackEvent(['Search results', 'Delete']);
      },

      paginationClick: function() {
        trackEvent(['Pagination', 'Click']);
      },

      deviceClick: function() {
        trackEvent(['Device', 'Click']);
      },

      omniboxSearch: function() {
        trackEvent(['Omnibox', 'Search']);
      },

      browserActionClick: function() {
        trackEvent(['Browser action', 'Click']);
      },

      contextMenuClick: function() {
        trackEvent(['Context menu', 'Click']);
      },

      selectionContextMenuClick: function() {
        trackEvent(['Selection context menu', 'Click']);
      },

      syncStorageError: function(operation, msg) {
        trackEvent(['Storage Error', operation, 'Sync', msg]);
      },

      syncStorageAccess: function(operation) {
        trackEvent(['Storage Access', operation, 'Sync']);
      },

      localStorageError: function(operation, msg) {
        trackEvent(['Storage Error', operation, 'Local', msg]);
      },

      mailingListPrompt: function() {
        trackEvent(['Mailing List Prompt', 'Seen']);
      },

      hourClick: function(hour) {
        trackEvent(['Visits', 'Hour Click', hour]);
      }
    };
  };

  BH.Trackers.AnalyticsTracker = AnalyticsTracker;
})();
