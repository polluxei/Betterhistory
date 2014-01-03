class BH.Views.WeeksResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['weeks_results']

  className: 'weeks_results_view'

  render: ->
    presenter = new BH.Presenters.AllWeeksPresenter(@collection)
    html = Mustache.to_html @template, presenter.allWeeks()
    @$el.html html
    @
