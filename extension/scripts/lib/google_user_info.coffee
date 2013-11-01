class BH.Lib.GoogleUserInfo
  constructor: (AuthClass) ->
    @googleAuth = new AuthClass 'google',
      client_id: '610387416050-7vb32pbtg40nk9ohvhm7dc45plfl2nmf.apps.googleusercontent.com',
      client_secret: 'R8EhqcoPB-PZwvxWOgA_TFvC',
      api_scope: 'https://www.googleapis.com/auth/userinfo.profile'

  fetch: (callbacks) ->
    @googleAuth.authorize =>
      token = @googleAuth.getAccessToken()
      url = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=#{token}"

      $.getJSON url , (data = {}) ->
        if data.sub?
          syncStore.set(authId: data.sub)
          callbacks.success()
        else
          callback.error()
