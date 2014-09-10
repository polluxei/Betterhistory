class BH.Views.DevicesListView extends Backbone.View
  @include BH.Modules.I18n

  className: 'devices_list_view'

  template: BH.Templates['devices_list']

  events:
    'click a': 'deviceClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker

  render: ->
    html = Mustache.to_html @template, devices: @collection.toJSON()
    @$el.append html
    @

  deviceClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)

    @$('.selected').removeClass('selected')
    $el.addClass('selected')

    @model.set name: $el.data('name')
