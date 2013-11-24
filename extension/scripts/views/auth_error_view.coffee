class BH.Views.AuthErrorView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'auth_error_view'
  template: BH.Templates['auth_error']

  events:
    'click .cancel': 'cancelClicked'
    'click .login': 'loginClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  cancelClicked: (ev) ->
    ev.preventDefault()
    @close()
    user.logout()

  loginClicked: (ev) ->
    ev.preventDefault()
    @close()
    user.logout()
    userProcessor = new BH.Lib.UserProcessor()
    userProcessor.start()

  getI18nValues: ->
    @t ['login_again_button', 'prompt_cancel_button', 'auth_error_title', 'auth_error_description']
