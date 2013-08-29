errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
analyticsTracker = new BH.Trackers.AnalyticsTracker(_gaq)

localStore = new BH.Lib.LocalStore
  chrome: chrome
  tracker: analyticsTracker

site = new BH.Models.Site {},
  chrome: chrome
  localStore: localStore

taggingView = new BH.Views.TaggingView
  el: $('.app')
  model: site
  tracker: analyticsTracker

site.fetch()
