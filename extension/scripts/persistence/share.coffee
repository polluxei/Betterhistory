class BH.Persistence.Share
  host: '$HOST$'

  constructor: (@remote = $.ajax) ->

  send: (sharedTag, callbacks) ->
    @remote
      url: "http://#{@host}/share"
      data: JSON.stringify(sharedTag)
      type: 'POST'
      dataType: 'json'
      contentType: 'application/json'
      success: (data) =>
        callbacks.success(data)
      error: ->
        callbacks.error()
