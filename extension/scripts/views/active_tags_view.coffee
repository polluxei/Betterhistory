class BH.Views.ActiveTagsView extends BH.Views.MainView
  @include BH.Modules.I18n

  template: BH.Templates['active_tags']

  className: 'active_tags_view'

  events:
    'click .delete': 'deleteTagClicked'
    'click .tag': 'tagClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @options.editable = true unless @options.editable?

  render: ->
    properties = @model.toJSON()
    properties.editable = @options.editable
    html = Mustache.to_html(@template, properties)
    @$el.html html
    @

  deleteTagClicked: (ev) ->
    ev.preventDefault()
    @model.removeTag $(ev.currentTarget).data('tag')
    @tracker.removeTagPopup()

  tagClicked: (ev) ->
    ev.preventDefault()
    tag = $(ev.currentTarget).data('tag')
    @tracker.tagPopupClick()
    @chromeAPI.tabs.create
      url: "chrome://history#tags/#{tag}"
