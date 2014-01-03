window.apiHost = '$API_HOST$'
window.siteHost = '$SITE_HOST$'
window.env = '$ENV$'

if env == 'prod'
  errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)

analyticsTracker = new BH.Trackers.AnalyticsTracker()

load = ->
  window.syncStore = new BH.Lib.SyncStore
    chrome: chrome
    tracker: analyticsTracker

  window.user = new BH.Models.User({})
  window.user.fetch()
  window.user.on 'change', ->
    @trigger('login') if @get('authId')

  window.user.on 'login', ->
    syncer = new BH.Lib.Syncer()
    syncer.updateIfNeeded()

  window.tagState = new Backbone.Model
    readOnly: false
    syncing: false

  settings = new BH.Models.Settings({})
  window.state = new BH.Models.State({}, settings: settings)

  window.persistence = new BH.Init.Persistence
    localStore: new BH.Lib.LocalStore
      chrome: chrome
      tracker: analyticsTracker
    syncStore: new BH.Lib.SyncStore
      chrome: chrome
      tracker: analyticsTracker
    ajax: $.ajax
    state: state

  chrome.tabs.query currentWindow: true, active: true, (tabs) =>
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

    site.fetch() unless tagState.get('readOnly')

    tagFeature = new BH.Init.TagFeature
      syncStore: syncStore
    tagFeature.announce ->
      $('body').addClass('new_tags')

if env == 'prod'
  try
    load()
  catch e
    errorTracker.report e
else
  load()

