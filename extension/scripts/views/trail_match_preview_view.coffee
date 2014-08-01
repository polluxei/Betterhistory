class BH.Views.TrailMatchPreviewView extends Backbone.View
  template: BH.Templates['trail_match_preview']

  render: ->
    presenter = new BH.Presenters.SearchHistoryPresenter(@collection.toJSON(), @options.query)
    html = Mustache.to_html @template, visits: presenter.history()
    @$el.html html
    @
