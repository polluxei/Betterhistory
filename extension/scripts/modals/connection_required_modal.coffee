class BH.Modals.ConnectionRequiredModal extends BH.Modals.Base
  @include BH.Modules.I18n

  className: 'connection_required_view'
  template: BH.Templates['connection_required']

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
    @t ['prompt_okay_button', 'connection_required_title', 'connection_required_description']
