class BH.Lib.UserProcessor
  start: ->
    googleUserInfo = new BH.Lib.GoogleUserInfo(OAuth2)
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
                    alert('We could not process your order at this time. Please contact hello@better-history.com')
          error: ->
            alert('There was a problem creating an account. Please contact hello@better-history.com')
      error: ->
        alert('There was a problem authorizing with Google. Please contact hello@better-history.com')

  loggedIn: (userData) ->
    syncStore.set authId: data.authId
    $('.sync_promo').hide()
    $('.sync_enabled').show()
