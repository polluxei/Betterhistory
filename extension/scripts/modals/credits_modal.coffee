class BH.Modals.CreditsModal extends BH.Modals.Base
  @include BH.Modules.I18n

  className: 'credits_view'
  template: BH.Templates['credits']

  events:
    'click .close': 'closeClicked'

  initialize: ->
    @chromeAPI = chrome
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  closeClicked: (ev) ->
    ev.preventDefault()
    @close()

  openClicked: (ev) ->
    ev.preventDefault()
    @open()

  getI18nValues: ->
    properties = @t [
      'credits_title',
      'translators_heading',
      'spanish',
      'swedish',
      'german',
      'french',
      'italian',
      'hungarian',
      'chinese_simplified',
      'arabic',
      'polish',
      'portuguese',
      'russian',
      'slovak',
      'catalonian',
      'hindi',
      'vietnamese',
      'japanese',
      'romanian',
      'czech',
      'dutch',
      'latvian',
      'turkish',
      'translation_help_heading',
      'close_button'
    ]
    properties['i18n_developed_by'] = @t('developed_by', [
      '<a href="http://automagical.posterous.com/">',
      '</a>',
      'Roy Kolak'
    ])
    properties['i18n_translation_instructions'] = @t('translation_instructions', [
      'roy.kolak@gmail.com',
      '<a href="mailto:roy.kolak@gmail.com">',
      '</a>'
    ])
    properties
