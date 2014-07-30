class BH.Init.Persistence
  constructor: (@config = {}) ->

  tag: ->
    throw "localStore requied" unless @config.localStore?

    @tagPersistence ||= new BH.Persistence.Tag
      localStore: @config.localStore

  remote: (authId) ->
    throw "Ajax requied" unless @config.ajax?
    authId = authId || user?.get('authId')

    @remotePersistence ||= new BH.Persistence.Remote(authId, @config.ajax)
    @remotePersistence.updateAuthId(authId) if authId?
    @remotePersistence
