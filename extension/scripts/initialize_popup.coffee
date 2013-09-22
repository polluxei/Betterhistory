errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
analyticsTracker = new BH.Trackers.AnalyticsTracker(_gaq)

window.localStore = new BH.Lib.LocalStore
  chrome: chrome
  tracker: analyticsTracker

window.syncStore = new BH.Lib.SyncStore
  chrome: chrome
  tracker: analyticsTracker

chrome.tabs.query active: true, (tabs) =>
  tab = tabs[0] || {}

  attrs =
    title: tab.title
    url: tab.url

  site = new BH.Models.Site attrs,
    chrome: chrome

  tags = new BH.Collections.Tags []

  taggingView = new BH.Views.TaggingView
    el: $('.app')
    model: site
    collection: tags
    tracker: analyticsTracker
  taggingView.render()

  site.fetch()

  syncStore.get 'tagInstructionsDismissed', (data) ->
    tagInstructionsDismissed = data.tagInstructionsDismissed || false
    unless tagInstructionsDismissed
      $('body').addClass('new_tags')
