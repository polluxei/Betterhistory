class BH.Views.DevicesResultsView extends Backbone.View
  @include BH.Modules.I18n

  className: 'devices_results_view'

  template: BH.Templates['devices_results']

  render: ->
    html = Mustache.to_html @template
    @$el.append html
    @
