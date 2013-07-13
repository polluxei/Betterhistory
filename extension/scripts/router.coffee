class BH.Router extends Backbone.Router
  routes:
    '': 'reset'
    'settings': 'settings'
    'search': 'search'
    'search/*query': 'search'
    'weeks/:id': 'week'
    'days/:id': 'day'

  initialize: ->
    settings = new BH.Models.Settings()
    settings.fetch()

    @state = new BH.Models.State({}, settings: settings)
    @state.fetch()
    @state.updateRoute()

    @app = new BH.Views.AppView
      el: $('.app')
      collection: new BH.Collections.Weeks(null, {settings: settings})
      settings: settings
      state: @state
    @app.render()

    @bind 'all', (route) =>
      window.scroll 0, 0
      if settings.get('openLocation') == 'last_visit'
        @state.set route: location.hash

    @reset if location.hash == ''

  reset: ->
    @navigate @state.get('route'), trigger: true

  week: (id) ->
    view = @app.loadWeek(id)
    view.select()
    @_delay -> view.history.fetch()

  day: (id) ->
    view = @app.loadDay id
    view.history.fetch()
    view.select()

  settings: ->
    view = @app.loadSettings()
    view.select()

  search: (query = '') ->
    # Load a fresh search view when the query is empty to
    # ensure a new WeekHistory instance is created because
    # this usually means a search has been canceled
    view = @app.loadSearch(expired: true if query == '')
    view.model.set query: decodeURIComponent(query)
    view.select()
    @_delay ->
      view.history.fetch() if view.model.validQuery()

  _delay: (callback) ->
    setTimeout (-> callback()), 250
