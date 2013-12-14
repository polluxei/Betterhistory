class BH.Modals.LoginErrorModal extends BH.Modals.Base
  @include BH.Modules.I18n

  className: 'login_error_view'
  template: BH.Templates['login_error']

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
    @t ['prompt_okay_button', 'login_error_title', 'login_error_description']
