showServerErrorView = ->
  serverErrorView = new BH.Views.ServerErrorView()
  serverErrorView.open()

class BH.Lib.UserProcessor
  constructor: ->
    @tracker = analyticsTracker

  start: ->
    if !navigator.onLine
      $('.login_spinner').hide()
      connectionRequiredView = new BH.Views.ConnectionRequiredView()
      connectionRequiredView.open()
    else
      googleUserInfo = new BH.Lib.GoogleUserInfo()
      googleUserInfo.fetch
        success: (userInfo) =>
          @tracker.userOAuthSuccess()
          sub = userInfo.sub
          $.ajax
            url: "http://#{window.apiHost}/user"
            data:
              subId: userInfo.sub
              email: userInfo.email
              avatar: userInfo.picture
              firstName: userInfo.given_name
              lastName: userInfo.family_name
            type: 'POST'
            dataType: 'json'
            success: (data) =>
              if data.purchased
                @loggedIn(data)
              else
                @tracker.userCreationSuccess()
                $.post "http://#{window.apiHost}/purchase/payment_token", {authId: data.authId}, (result) =>
                  google.payments.inapp.buy
                    parameters: {}
                    jwt: result.jwt
                    success: =>
                      @loggedIn(data)
                      @tracker.syncPurchaseSuccess()
                    failure: ->
                      # purchase failure
                      @tracker.syncPurchaseFailure()
            error: =>
              showServerErrorView()
              @tracker.userCreationFailure()
              $('.login_spinner').hide()
        error: =>
          showServerErrorView()
          @tracker.userOAuthFailure()
          $('.login_spinner').hide()

  loggedIn: (userData) ->
    @tracker.userLoggedIn()
    persistence.tag().fetchTags (tags, compiledTags) =>
      if tags.length > 0
        syncingTranslator = new BH.Lib.SyncingTranslator()
        syncingTranslator.forServer compiledTags, (sites) =>

          sitesHasher = new BH.Lib.SitesHasher(CryptoJS.SHA1)
          sites = sitesHasher.generate(sites).toString()

          if userData.sites?
            if userData.sites == sites
              @initialSync(null, userData)
            else
              @syncDecision(userData)
          else
            if tags.length != 0
              @initialSync('push', userData)
            else
              @initialSync('push', userData) # doesn't really matter
      else
        @initialSync('pull', userData)

  syncDecision: (userData) ->
    syncingDecisionView = new BH.Views.SyncingDecisionView
      model: new Backbone.Model(userData)
    syncingDecisionView.open()

    syncingDecisionView.on 'decision', (decision) =>

      if decision == 'push'
        @pushLocalTags userData, ->
          syncingDecisionView.doneSyncing()

      else
        @pullRemoteTags userData, ->
          syncingDecisionView.doneSyncing()

    syncingDecisionView.on 'syncingComplete', ->
      window.user.login(userData)

  initialSync: (direction, userData) ->
    initialSyncingView = new BH.Views.InitialSyncingView()
    initialSyncingView.open()

    initialSyncingView.on 'open', =>
      if direction == 'push'
        @pushLocalTags userData, ->
          initialSyncingView.doneSyncing()
      else if direction == 'pull'
        @pullRemoteTags userData, ->
          initialSyncingView.doneSyncing()
      else if direction == null
        initialSyncingView.doneSyncing()

    initialSyncingView.on 'syncingComplete', ->
      window.user.login(userData)

  pushLocalTags: (userData, callback) ->
    persistence.remote(userData.authId).deleteSites ->
      persistence.tag().fetchTags (tags, compiledTags) ->
        if tags.length == 0
          callback()
        else
          syncingTranslator = new BH.Lib.SyncingTranslator()
          syncingTranslator.forServer compiledTags, (sites) ->
            persistence.remote().updateSites sites, ->
              setTimeout (-> callback()), 2000

  pullRemoteTags: (userData, callback) ->
    persistence.tag().removeAllTags ->
      persistence.remote(userData.authId).getSites (sites) ->
        syncingTranslator = new BH.Lib.SyncingTranslator()
        data = syncingTranslator.forLocal sites
        persistence.tag().import data, ->
          setTimeout (-> callback()), 2000
