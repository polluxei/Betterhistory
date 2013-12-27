class BH.Views.Cache
  constructor: (@options) ->
    @settings = @options.settings
    @state = @options.state
    @expire()

  expire: ->
    @cache =
      weeks: {}
      days: {}
      tags: {}

  tagsView: ->
    if !@cache.allTags
      tags = new BH.Collections.Tags []

      @cache.allTags = new BH.Views.TagsView
        collection: tags
        state: @state

      @insert @cache.allTags.render().el

    @cache.allTags

  tagView: (id) ->
    if !@cache.tags[id]
      tag = new BH.Models.Tag(name: id)

      @cache.tags[id] = new BH.Views.TagView
        name: id
        model: tag
        state: @state
      @insert @cache.tags[id].render().el

    @cache.tags[id]

  weeksView: () ->
    return @cache.allWeeks if @cache.allWeeks

    @cache.allWeeks = new BH.Views.WeeksView
      collection: new Backbone.Collection()

    @insert @cache.allWeeks.render().el
    @cache.allWeeks

  weekView: (id) ->
    return @cache.weeks[id] if @cache.weeks[id]

    @cache.weeks[id] = new BH.Views.WeekView
      model: new Backbone.Model(id: id, date: new Date(id))
      collection: new Backbone.Collection()

    @insert @cache.weeks[id].render().el
    @cache.weeks[id]

  dayView: (id) ->
    return @cache.days[id] if @cache.days[id]

    @cache.days[id] = new BH.Views.DayView
      model: new Backbone.Model(id: id, date: new Date(id))
      collection: new Backbone.Collection()

    @insert @cache.days[id].render().el
    @cache.days[id]

  searchView: (options)->
    return @cache.search if @cache.search || options.expired == true

    @cache.search = new BH.Views.SearchView
      model: new BH.Models.Search()

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

