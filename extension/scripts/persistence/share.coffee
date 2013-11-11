class BH.Persistence.Share
  constructor: (@remote = $.ajax) ->

  send: (sharedTag, callbacks) ->
    @remote
      url: "http://#{window.apiHost}/share"
      data: JSON.stringify(sharedTag)
      type: 'POST'
      dataType: 'json'
      contentType: 'application/json'
      success: (data) =>
        callbacks.success(data)
      error: ->
        callbacks.error()
