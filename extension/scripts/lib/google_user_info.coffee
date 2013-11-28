class BH.Lib.GoogleUserInfo
  fetch: (callbacks) ->
    chrome.identity.getAuthToken {'interactive': true}, (token) ->
      if token?
        $.ajax
          url: "https://www.googleapis.com/oauth2/v3/userinfo"
          dataType: 'json'
          headers:
            "Authorization": "OAuth #{token}"
          success: (data) ->
            if data.sub?
              callbacks.success(data)
            else
              callbacks.error()
          error: (data) ->
            callbacks.error() if callbacks.errors
      else
        $('.login_spinner').hide()
        alert('Please sign into Chrome before continuing')

  revoke: ->
    chrome.identity.getAuthToken (token) ->
      $.get "https://accounts.google.com/o/oauth2/revoke?token=#{token}"
      chrome.identity.removeCachedAuthToken token: token, ->
