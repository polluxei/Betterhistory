class BH.Lib.GoogleUserInfo
  fetch: (callbacks) ->
    chrome.identity.getAuthToken {'interactive': true}, (token) ->
      $.ajax
        url: "https://www.googleapis.com/oauth2/v3/userinfo"
        dataType: 'json'
        headers:
          "Authorization": "OAuth #{token}"
        success: (data) ->
          if data.sub?
            callbacks.success(data)
          else
            callback.error()
        error: (data) ->
          callback.error()
