class BH.Modals.ReadOnlyExplanationModal extends BH.Modals.Base
  @include BH.Modules.I18n

  className: 'read_only_explanation_view'
  template: BH.Templates['read_only_explanation']

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
    @t ['prompt_okay_button', 'read_only_explanation_title', 'read_only_explanation_description']
