class BH.Views.VisitsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'visits_view'

  template: BH.Templates['visits']

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker

  pageTitle: ->
    'Visits'

  render: ->
    properties = _.extend @getI18nValues(), {}
    html = Mustache.to_html @template, properties
    @$el.append html
    @

  getI18nValues: ->
    @t ['search_input_placeholder_text']
