class BH.Views.RenameTagView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'rename_tag_view'
  template: BH.Templates['rename_tag']

  events:
    'click .cancel': 'cancelClicked'
    'click .rename': 'renameClicked'

  initialize: ->
    @chromeAPI = chrome
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  cancelClicked: (ev) ->
    ev.preventDefault()
    @close()

  renameClicked: (ev) ->
    ev.preventDefault()
    tag = @$('input.new_tag').val()
    tag = tag.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
    return false if tag.length == 0

    @model.renameTag @$('input.new_tag').val(), =>
      @close()

  getI18nValues: ->
    properties = @t ['rename_tag_button', 'prompt_cancel_button', 'new_tag_placeholder']
    properties['i18n_rename_tag_title'] = @t('rename_tag_title', [
      @model.get('name')
    ])
    properties
