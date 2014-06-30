class BH.Router extends Backbone.Router
  routes:
    '': 'reset'
    'tags': 'tags'
    'tags/:id': 'tag'
    'devices': 'devices'
    'settings': 'settings'
    'search/*query(/p:page)(?*filterString)': 'search'
    'search': 'search'
    'trails/new': 'newTrail'
    'trails/:name': 'trail'

  initialize: (options) ->
    settings = options.settings
    tracker = options.tracker

    @trails = new Backbone.Collection()

    @app = new BH.Views.AppView
      el: $('.app')
      settings: settings
      trails: @trails
    @app.render()

  tags: ->
    view = @app.loadTags()
    view.select()
    delay ->
      view.collection.fetch()

  devices: ->
    view = @app.loadDevices()
    view.select()
    delay -> view.collection.fetch()

  tag: (id) ->
    view = @app.loadTag(id)
    view.select()
    delay ->
      view.model.fetch()

  newTrail: ->
    view = @app.loadNewTrail()
    view.select()
    view.on 'build_trail', (model) =>
      @trails.add model

  trail: (name) ->
    view = @app.loadTrail(name)
    view.select()

  settings: ->
    view = @app.loadSettings()
    view.select()

  search: (query, page, filterString) ->
    filter = BH.Lib.QueryParams.read filterString

    # Load a fresh search view when the query is empty to
    # ensure a new WeekHistory instance is created because
    # this usually means a search has been canceled
    view = @app.loadSearch(expired: true if query == '' || page)
    view.page.set(page: parseInt(page, 10), {silent: true}) if page?
    view.model.set
      query: decodeURIComponent(query)
      filter: filter
    view.select()
    delay ->
      # Super shitty, definitely need to move
      options = if filter.week
        startTime: moment(new Date(filter.week)).startOf('day').valueOf()
        endTime: moment(new Date(filter.week)).add('days', 6).endOf('day').valueOf()
      else if filter.day
        startTime: moment(new Date(filter.day)).startOf('day').valueOf()
        endTime: moment(new Date(filter.day)).endOf('day').valueOf()

      if query != ''
        new BH.Lib.SearchHistory(query).fetch options, (history, cacheDatetime = null) ->
          view.collection.reset history
          if cacheDatetime?
            view.model.set cacheDatetime: cacheDatetime
          else
            view.model.unset 'cacheDatetime'

delay = (callback) ->
  setTimeout (-> callback()), 250
