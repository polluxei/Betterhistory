class BH.Init.Persistence
  constructor: (@config = {}) ->

  tag: ->
    throw "localStore requied" unless @config.localStore?

    @tagPersistence ||= new BH.Persistence.Tag
      localStore: @config.localStore

  remote: (authId) ->
    authId = authId || user.get('authId')

    throw "Ajax requied" unless @config.ajax?
    throw "AuthId required" unless authId?

    @remotePersistence ||= new BH.Persistence.Remote(authId, @config.ajax, state)
