class BH.Views.ServerErrorView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'server_error_view'
  template: BH.Templates['server_error']

  events:
    'click .okay': 'okayClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  okayClicked: (ev) ->
    ev.preventDefault()
    @close()

  getI18nValues: ->
    @t ['prompt_okay_button', 'server_error_title', 'server_error_description']
