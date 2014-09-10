class BH.Views.DevicesView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'devices_view with_controls'

  template: BH.Templates['devices']

  events:
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @collection.on 'reset', @onCollectionReset, @

    @model = new Backbone.Model()

  pageTitle: ->
    @t('devices_title')

  render: ->
    properties = _.extend @getI18nValues(),
      devices: @collection.toJSON()
    html = Mustache.to_html @template, properties
    @$el.append html

    devicesResultsView = new BH.Views.DevicesResultsView
      model: @model
      collection: new Backbone.Collection()
      el: @$('.content')
    @

  onCollectionReset: ->
    @$('.devices_list_view').remove()

    devicesListView = new BH.Views.DevicesListView
      collection: @collection
      model: @model
    @$('header').append devicesListView.render().el

  getI18nValues: ->
    properties = @t ['devices_title', 'search_input_placeholder_text']
    properties
