class BH.Views.ActiveTagsView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['active_tags']

  className: 'active_tags_view'

  events:
    'click .delete': 'deleteTagClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker

  render: ->
    properties = tags: @model.tags()
    html = Mustache.to_html(@template, properties)
    @$el.html html
    @

  deleteTagClicked: (ev) ->
    ev.preventDefault()
    @model.removeTag $(ev.currentTarget).data('tag')
    @tracker.removeTagPopup()
