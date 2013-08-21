tracker = new BH.Lib.Tracker(_gaq)

localStore = new BH.Lib.LocalStore
  chrome: chrome
  tracker: tracker

site = new BH.Models.Site {},
  chrome: chrome
  localStore: localStore

taggingView = new BH.Views.TaggingView
  el: $('.app')
  model: site

site.fetch()
