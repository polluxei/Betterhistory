window.apiHost = '$API_HOST$'
window.siteHost = '$SITE_HOST$'
window.env = '$ENV$'

window.errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
window.analyticsTracker = new BH.Trackers.AnalyticsTracker(_gaq)

load = ->
  analyticsTracker.historyOpen()

  window.syncStore = new BH.Lib.SyncStore
    chrome: chrome
    tracker: analyticsTracker

  syncStore.get 'authId', (data = {}) ->
    $('body').addClass 'logged_in' if data.authId?

  new BH.Lib.DateI18n().configure()

  window.user = new BH.Models.User({})
  window.user.fetch()

  window.user.on 'change', ->
    @trigger('login') if @get('authId')

  window.user.on 'logout', ->
    googleUserInfo = new BH.Lib.GoogleUserInfo()
    googleUserInfo.revoke()

  window.user.on 'login', ->
    persistence.remote().userInfo (data) ->
      if data.sites?
        persistence.tag().fetchTags (tags, compiledTags) =>

          if tags.length > 0
            syncingTranslator = new BH.Lib.SyncingTranslator()
            syncingTranslator.forServer compiledTags, (sites) =>

              sitesHasher = new BH.Lib.SitesHasher(CryptoJS.SHA1)
              sites = sitesHasher.generate(sites).toString()

              if sites != data.sites
                persistence.remote().deleteSites ->
                  syncingTranslator.forServer compiledTags, (sites) ->
                    persistence.remote().updateSites sites, ->

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

  settings.fetch
    success: =>
      state.fetch
        success: =>
          state.updateRoute()

          window.router = new BH.Router
            settings: settings
            state: state
            tracker: analyticsTracker

          Backbone.history.start()

  mailingList = new BH.Init.MailingList(syncStore: syncStore)
  mailingList.prompt ->
    new BH.Views.MailingListView().open()
    analyticsTracker.mailingListPrompt()

  tagFeature = new BH.Init.TagFeature(syncStore: syncStore)
  tagFeature.announce ->
    $('body').addClass('new_tags')

if env == 'prod'
  try
    load()
  catch e
    errorTracker.report e
else
  load()

