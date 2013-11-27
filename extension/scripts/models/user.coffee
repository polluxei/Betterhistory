class BH.Models.User extends Backbone.Model
  storeName: 'user'

  initialize: () ->
    @chromeAPI = chrome
    @loggedIn = false

  fetch: ->
    @chromeAPI.storage.sync.get 'user', (data) =>
      @login(data.user) if data.user?.authId?

  save: ->
    @chromeAPI.storage.sync.set user: @toJSON()

  login: (data)->
    @set(data)
    @save()
    @trigger('login')
    @loggedIn = true

  logout: ->
    @clear(silent: true)
    @save()
    @trigger('logout')
    @loggedIn = false

  isLoggedIn: ->
    @loggedIn
