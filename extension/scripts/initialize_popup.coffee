errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
analyticsTracker = new BH.Trackers.AnalyticsTracker(_gaq)

localStore = new BH.Lib.LocalStore
  chrome: chrome
  tracker: analyticsTracker

persistence = new BH.Persistence.Tag
  localStore: localStore

site = new BH.Models.Site {},
  chrome: chrome
  persistence: persistence

taggingView = new BH.Views.TaggingView
  el: $('.app')
  model: site
  tracker: analyticsTracker

site.fetch()
