class BH.Views.AppView extends Backbone.View
  @include BH.Modules.I18n

  className: 'app_view'

  template: BH.Templates['app']

  initialize: (options)->
    @chromeAPI = chrome
    @cache = new BH.Views.Cache(@options)

    @menuView = new BH.Views.MenuView collection: options.trails

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.html html

    @$('.navigation').append @menuView.render().el

    @

  loadTags: ->
    @updateMenuSelection()
    @$('.menu .tags').parent().addClass 'selected'
    @cache.tagsView()

  loadDevices: ->
    @updateMenuSelection()
    @$('.menu .devices').parent().addClass 'selected'
    @cache.devicesView()

  loadTag: (id) ->
    @updateMenuSelection()
    @$('.menu .tags').parent().addClass 'selected'
    @cache.tagView(id)

  loadNewTrail: ->
    @updateMenuSelection()
    @$('.menu .new_trail').parent().addClass 'selected'
    @cache.newTrailView()

  loadSettings: ->
    @updateMenuSelection()
    @$('.menu .setting').parent().addClass 'selected'
    @cache.settingsView()

  loadSearch: (options = {}) ->
    @updateMenuSelection()
    @cache.searchView(options)

  updateMenuSelection: (id) ->
    @$('.menu > *').removeClass 'selected'

  getI18nValues: ->
    @t ['history_title']
