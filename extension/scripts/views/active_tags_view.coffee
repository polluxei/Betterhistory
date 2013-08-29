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

  render: ->
    html = Mustache.to_html(@template, @model.toJSON())
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
