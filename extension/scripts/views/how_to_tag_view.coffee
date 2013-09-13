class BH.Views.HowToTagView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'how_to_tag_view'
  template: BH.Templates['how_to_tag']

  events:
    'click .done': 'doneClicked'

  initialize: ->
    @chromeAPI = chrome
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  doneClicked: (ev) ->
    ev.preventDefault()
    @close()

  getI18nValues: ->
    @t ['how_to_tag_title', 'prompt_done_button']
