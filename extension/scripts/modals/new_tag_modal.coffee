class BH.Modals.NewTagModal extends BH.Modals.Base
  @include BH.Modules.I18n

  className: 'new_tag_view'
  template: BH.Templates['new_tag']

  events:
    'click .cancel': 'cancelClicked'
    'click .rename': 'newTagClicked'
    'keyup .new_tag': 'newTagKeyup'

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

  newTagKeyup: ->
    @$('input.new_tag').removeClass('error')

  newTagClicked: (ev) ->
    ev.preventDefault()
    tag = @$('input.new_tag').val()
    @model.set(name: tag, {validate: true})
    if @model.validationError
      @$('input.new_tag').addClass('error')
    else
      @close()

  getI18nValues: ->
    @t ['new_tag_button', 'prompt_cancel_button', 'new_tag_placeholder', 'create_new_tag_title']
