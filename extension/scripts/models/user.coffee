class BH.Models.User extends Backbone.Model
  storeName: 'user'

  initialize: () ->
    @chromeAPI = chrome

  fetch: ->
    @chromeAPI.storage.sync.get 'user', (data) =>
      @set(data.user)

  save: ->
    @chromeAPI.storage.sync.set user: @toJSON()

  login: (data)->
    @set(data)
    @save()
    @trigger('login')

  logout: ->
    @clear(silent: true)
    @save()
    @trigger('logout')
