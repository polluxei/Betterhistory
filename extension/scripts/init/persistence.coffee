class BH.Init.Persistence
  constructor: (@config = {}) ->

  tag: ->
    throw "localStore requied" unless @config.localStore?

    @tagPersistence ||= new BH.Persistence.Tag
      localStore: @config.localStore

  remote: (authId) ->
    throw "Ajax requied" unless @config.ajax?
    throw "State required" unless @config.state?

    @remotePersistence ||= new BH.Persistence.Remote(authId, @config.ajax, @config.state)
    @remotePersistence.updateAuthId(authId) if authId?
    @remotePersistence
