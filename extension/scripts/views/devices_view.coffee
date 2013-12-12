class BH.Views.DevicesView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'devices_view'

  template: BH.Templates['devices']

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker

  pageTitle: ->
    @t('devices_title')

  render: ->
    properties = _.extend @getI18nValues(), {}
    html = Mustache.to_html @template, properties
    @$el.append html
    @

  getI18nValues: ->
    properties = @t ['devices_title', 'search_input_placeholder_text']
    properties
