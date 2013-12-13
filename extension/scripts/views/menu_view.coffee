class BH.Views.MenuView extends Backbone.View
  template: BH.Templates['menu']

  events:
    'click .menu > *': 'weekClicked'

  render: ->
    presenter = new BH.Presenters.WeeksPresenter(@collection)
    html = Mustache.to_html @template, presenter.weeks()
    @$el.html html

  weekClicked: (ev) ->
    @$('.menu > *').removeClass 'selected'
    $el = $(ev.currentTarget)
    $el.addClass 'selected'
    analyticsTracker.weekView($el.data('week-id'), $el.index())
