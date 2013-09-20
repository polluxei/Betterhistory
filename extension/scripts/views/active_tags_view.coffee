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
    @editable = @options.editable || false
    @inBrowserAction = @options.inBrowserAction || false

  render: ->
    properties = tags: @model.tags(), editable: @editable
    html = Mustache.to_html(@template, properties)
    @$el.html html
    @

  deleteTagClicked: (ev) ->
    ev.preventDefault()
    @model.removeTag $(ev.currentTarget).data('tag')

  tagClicked: (ev) ->
    if @inBrowserAction?
      ev.preventDefault()
      tag = $(ev.currentTarget).data('tag')
      @chromeAPI.tabs.create
        url: "chrome://history#tags/#{tag}"
