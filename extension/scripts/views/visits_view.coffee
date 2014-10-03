class BH.Views.VisitsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'visits_view'

  template: BH.Templates['visits']

  events:
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @collection.on 'reset', @onCollectionReset, @
    @model.on 'change:date', @onDateChange, @

    @feature = new Backbone.Model(supported: true)
    @feature.on 'change:supported', @onFeatureSupportedChange, @

  pageTitle: ->
    'Activity'

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.append html

    @timelineView = new BH.Views.TimelineView
      model: @model
      el: @$('.timeline_view')
    @timelineView.render()

    @visitsResultsView = new BH.Views.VisitsResultsView
      collection: @collection
      model: @model
      el: @$('.visits_content')

    @

  onDateChange: (ev) ->
    @timelineView.render()
    @visitsResultsView.resetRender()

  onCollectionReset: ->
    @visitsResultsView.render()
    @assignTabIndices('.visits > .visit > a.item')

  onFeatureSupportedChange: ->
    @tracker.featureNotSupported('Query (by day)')
    @browserFeatureNotSupported()

  getI18nValues: ->
    @t ['search_input_placeholder_text']
