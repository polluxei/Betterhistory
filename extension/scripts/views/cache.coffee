class BH.Views.Cache
  constructor: (@options) ->
    @settings = @options.settings
    @state = @options.state
    @expire()

  expire: ->
    @cache =
      tags: {}

  tagsView: ->
    if !@cache.allTags
      tags = new BH.Collections.Tags []

      @cache.allTags = new BH.Views.TagsView
        collection: tags
        state: @state

      @insert @cache.allTags.render().el

    @cache.allTags

  devicesView: ->
    if !@cache.devices
      devices = new BH.Collections.Devices()

      @cache.devices = new BH.Views.DevicesView
        collection: devices
        state: @state

      @insert @cache.devices.render().el

    @cache.devices

  tagView: (id) ->
    if !@cache.tags[id]
      tag = new BH.Models.Tag(name: id)

      @cache.tags[id] = new BH.Views.TagView
        name: id
        model: tag
        state: @state
      @insert @cache.tags[id].render().el

    @cache.tags[id]

  searchView: (options)->
    return @cache.search if @cache.search || options.expired == true

    @cache.search = new BH.Views.SearchView
      model: new Backbone.Model()
      collection: new Backbone.Collection()

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
