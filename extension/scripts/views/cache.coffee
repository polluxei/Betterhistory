class BH.Views.Cache
  constructor: (@options) ->
    @settings = @options.settings
    @state = @options.state
    @expire()

  expire: ->
    @cache =
      weeks: {}
      days: {}

  tagsView: ->
    if !@cache.tags
      @cache.tags = new BH.Views.TagsView
        state: @state
      @insert @cache.tags.render().el

    @cache.tags

  tagView: (id) ->
    if !@cache.tag
      @cache.tag = new BH.Views.TagView
        name: id
        state: @state
      @insert @cache.tag.render().el

    @cache.tag

  weekView: (id) ->
    if !@cache.weeks[id]
      week = new BH.Models.Week(
        {date: moment(new Date(id))},
        {settings: @settings}
      )
      history = new BH.Models.WeekHistory(week.toHistory())

      @cache.weeks[id] = new BH.Views.WeekView
        model: week
        history: history

      @insert @cache.weeks[id].render().el

    @cache.weeks[id]

  dayView: (id) ->
    if !@cache.days[id]
      day =     new BH.Models.Day {date: moment(new Date(id))}, settings: @settings
      history = new BH.Models.DayHistory day.toHistory(), settings: @settings

      @cache.days[id] = new BH.Views.DayView
        model: day
        history: history

      @insert @cache.days[id].render().el

    @cache.days[id]

  searchView: (options)->
    if !@cache.search || options.expired
      search =  new BH.Models.Search()
      history = new BH.Models.SearchHistory(search.toHistory())

      @cache.search = new BH.Views.SearchView
        model: search
        history: history

      @insert @cache.search.render().el
    @cache.search

  settingsView: ->
    if !@cache.settings
      @cache.settings = new BH.Views.SettingsView
        model: @settings
        state: @state
      @insert @cache.settings.render().el

    @cache.settings

  insert: (html) ->
    $('.mainview').append html

