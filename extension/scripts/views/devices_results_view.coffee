class BH.Views.DevicesResultsView extends Backbone.View
  @include BH.Modules.I18n

  className: 'devices_results_view'

  template: BH.Templates['devices_results']

  initialize: ->
    @model.on 'change:name', @onDeviceChange, @
    @collection.on 'reset', @render, @

  render: ->
    properties = _.extend @getI18nValues(), sessions: @collection.toJSON()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onDeviceChange: ->
    historian = new Historian.Devices()
    historian.fetchSessions @model.get('name'), (visits) =>
      @collection.reset visits

  getI18nValues: ->
    @t [
      'no_visits_found'
      'search_by_domain'
    ]
