class BH.Router extends Backbone.Router
  routes:
    '': 'visits'
    'tags': 'tags'
    'tags/:id': 'tag'
    'devices': 'devices'
    'settings': 'settings'
    'search/*query(/p:page)': 'search'
    'search': 'search'
    'visits(/:date)': 'visits'
    'trails/new': 'newTrail'
    'trails/:name': 'trail'

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
    [view, transitioningView] = @cache.view('tags')

    delay transitioningView, ->
      view.collection.fetch()

  devices: ->
    [view, transitioningView] = @cache.view('devices')

    delay transitioningView, ->
      view.collection.fetch()

  tag: (id) ->
    [view, transitioningView] = @cache.view('tag', [id])
    delay transitioningView, ->
      view.model.fetch()

  newTrail: ->
    view = @cache.view('newTrail')
    view.on 'build_trail', (model) =>
      @trails.add model

  trail: (name) ->
    view = @cache.view('trail')

  visits: (date = 'today') ->
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
        view.collection.reset history

  settings: ->
    view = @cache.view('settings')

  search: (query, page) ->
    [view] = @cache.view('search')
    view.page.set(page: parseInt(page, 10), {silent: true}) if page?
    view.model.set query: decodeURIComponent(query)
    delay ->
      if query? && query != ''
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
