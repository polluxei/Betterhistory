class BH.Router extends Backbone.Router
  routes:
    '': 'reset'
    'tags': 'tags'
    'tags/:id': 'tag'
    'weeks/:id': 'week'
    'days/:id': 'day'
    'settings': 'settings'
    'search/*query(/p:page)': 'search'
    'search': 'search'

  initialize: (options) ->
    settings = options.settings
    tracker = options.tracker
    @state = options.state

    @app = new BH.Views.AppView
      el: $('.app')
      collection: new BH.Collections.Weeks(null, {settings: settings})
      settings: settings
      state: @state
    @app.render()

    @on 'route', (route) =>
      tracker.pageView(Backbone.history.getFragment())
      window.scroll 0, 0
      if settings.get('openLocation') == 'last_visit'
        @state.set route: location.hash

    @reset if location.hash == ''

  reset: ->
    @navigate @state.get('route'), trigger: true

  tags: ->
    view = @app.loadTags()
    view.select()

  tag: (id) ->
    view = @app.loadTag(id)
    view.select()

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

  search: (query = '', page) ->
    # Load a fresh search view when the query is empty to
    # ensure a new WeekHistory instance is created because
    # this usually means a search has been canceled
    view = @app.loadSearch(expired: true if query == '' || page)
    view.page.set(page: parseInt(page, 10), {silent: true}) if page?
    view.model.set query: decodeURIComponent(query)
    view.select()
    @_delay ->
      view.history.fetch() if view.model.validQuery()

  _delay: (callback) ->
    setTimeout (-> callback()), 250
