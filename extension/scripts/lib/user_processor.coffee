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
    persistence = new BH.Persistence.Tag(localStore: localStore)
    persistence.fetchTags (tags) =>
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
    syncingDecisionView.on 'decision', (decision) ->

      if decision == 'push'
        @pushLocalTags userData, ->
          syncingDecisionView.doneSyncing()

      else
        @pullRemoteTags userData, ->
          syncingDecisionView.doneSyncing()

    syncingDecisionView.on 'syncingComplete', ->
      window.user.login(userData)

  initialSync: (direction, userData) ->
    syncPersistence = new BH.Persistence.Sync(userData.authId, $.ajax)
    persistence = new BH.Persistence.Tag(localStore: localStore)

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
    syncPersistence = new BH.Persistence.Sync(userData.authId, $.ajax)
    persistence = new BH.Persistence.Tag(localStore: localStore)

    syncPersistence.deleteSites ->
      persistence.fetchTags (tags, compiledTags) ->
        if tags.length == 0
          callback()
        else
          tagSyncingFormatter = new BH.Lib.TagSyncingFormatter(localStore)
          tagSyncingFormatter.forServer compiledTags, (sites) ->
            syncPersistence.updateSites sites, ->
              callback()

  pullRemoteTags: (userData, callback) ->
    syncPersistence = new BH.Persistence.Sync(userData.authId, $.ajax)
    persistence = new BH.Persistence.Tag(localStore: localStore)

    persistence.removeAllTags ->
      syncPersistence.getSites (sites) ->
        syncingTranslator = new BH.Lib.SyncingTranslator()
        data = syncingTranslator.forLocal sites
        persistence.import data, ->
          callback()
