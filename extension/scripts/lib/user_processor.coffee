class BH.Lib.UserProcessor
  start: ->
    googleUserInfo = new BH.Lib.GoogleUserInfo()
    googleUserInfo.fetch
      success: (userInfo) =>
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
              $.post "http://#{window.apiHost}/purchase/payment_token", {authId: data.authId}, (result) =>
                google.payments.inapp.buy
                  parameters: {}
                  jwt: result.jwt
                  success: =>
                    @loggedIn(data)
                  failure: ->
                    # purchase failure
          error: ->
            alert('There was a problem creating an account. Please contact hello@better-history.com')
      error: ->
        alert('There was a problem authorizing with Google. Please contact hello@better-history.com')

  loggedIn: (userData) ->
    persistence.tag().fetchTags (tags) =>
      if userData.numberOfSites == 0 && tags.length != 0
        @initialSync('push', userData)
      else if userData.numberOfSites != 0 && tags.length == 0
        @initialSync('pull', userData)
      else if userData.numberOfSites == 0 && tags.length == 0
        @initialSync('push', userData) # doesn't really matter
      else
        @syncDecision(userData)

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
      else
        @pullRemoteTags userData, ->
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
            persistence.remote(userData.authId).updateSites sites, ->
              setTimeout (-> callback()), 2000

  pullRemoteTags: (userData, callback) ->
    persistence.tag().removeAllTags ->
      persistence.remote(userData.authId).getSites (sites) ->
        syncingTranslator = new BH.Lib.SyncingTranslator()
        data = syncingTranslator.forLocal sites
        persistence.tag().import data, ->
          setTimeout (-> callback()), 2000
