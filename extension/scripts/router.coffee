class BH.Router extends Backbone.Router
  routes:
    '': 'visits'
    'tags': 'tags'
    'tags/:id': 'tag'
    'devices': 'devices'
    'settings': 'settings'
    'search(/*query)': 'search'
    'visits(/:date)': 'visits'

  initialize: (options) ->
    settings = options.settings
    tracker = options.tracker

    @cache = new BH.Views.Cache
      settings: settings

    @trails = new Backbone.Collection()

    @app = new BH.Views.AppView
      el: $('.app')
      settings: settings
      trails: @trails
    @app.render()

    @on 'route', ->
      url = Backbone.history.getFragment()
      window.analyticsTracker.pageView url

  tags: ->
    @app.selectNav '.tags'

    [view, transitioningView] = @cache.view('tags')

    delay transitioningView, ->
      view.collection.fetch()

  devices: ->
    @app.selectNav '.devices'

    [view, transitioningView] = @cache.view('devices')

    delay transitioningView, ->
      new Historian.Devices().fetch (devices) ->
        if devices
          view.collection.reset devices
        else
          view.feature.set supported: false

  tag: (id) ->
    @app.selectNav '.tags'
    [view, transitioningView] = @cache.view('tag', [id])
    delay transitioningView, ->
      view.model.fetch()

  visits: (date = 'today') ->
    @app.selectNav '.visits'

    # special cases
    date = switch date
      when 'today'
        moment()
      when 'yesterday'
        moment().subtract('days', 1)
      else
        moment(new Date(date))

    date = date.startOf('day').toDate()

    [view, transitioningView] = @cache.view('visits', [date])

    delay transitioningView, ->
      new Historian.Day(date).fetch (history) ->
        if history
          view.collection.reset history
        else
          view.feature.set supported: false

  settings: ->
    @app.selectNav '.settings'
    view = @cache.view('settings')

  search: (query) ->
    @app.selectNav '.search'
    [view] = @cache.view('search')
    view.model.set query: decodeURIComponent(query) if query

    delay true, ->
      if query?
        view.historian = new Historian.Search(query)
        view.historian.fetch {}, (history, cacheDatetime = null) ->
          view.collection.reset history
          if cacheDatetime?
            view.model.set cacheDatetime: cacheDatetime
          else
            view.model.unset 'cacheDatetime'

# if we need to transition to another view, delay the query until the
# transition fires. There can be a noticeable lag if the delay is skipped
delay = (shouldDelay, callback) ->
  if shouldDelay
    setTimeout (-> callback()), 250
  else
    callback()
