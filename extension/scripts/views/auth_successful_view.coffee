class BH.Views.AuthSuccessfulView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'auth_success_view'
  template: BH.Templates['auth_successful']

  events:
    'click .done': 'doneClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  doneClicked: (ev) ->
    ev.preventDefault()
    @close()

  getI18nValues: ->
    @t ['prompt_done_button', 'auth_success_title', 'auth_success_description']
