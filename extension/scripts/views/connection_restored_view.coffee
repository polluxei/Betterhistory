class BH.Views.ConnectionRestoredView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'connection_restored_view'
  template: BH.Templates['connection_restored']

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
    @t ['prompt_okay_button', 'connection_restored_title', 'connection_restored_description']
