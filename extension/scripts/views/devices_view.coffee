class BH.Views.DevicesView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'devices_view'

  template: BH.Templates['devices']

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @collection.on 'reset', @onCollectionReset, @

  pageTitle: ->
    @t('devices_title')

  render: ->
    properties = _.extend @getI18nValues(), {}
    html = Mustache.to_html @template, properties
    @$el.append html
    @

  onCollectionReset: ->
    devicesResultsView = new BH.Views.DevicesResultsView
      collection: @collection
      el: @$('.content')

    devicesResultsView.render()

  getI18nValues: ->
    properties = @t ['devices_title', 'search_input_placeholder_text']
    properties
