class BH.Modals.MailingListModal extends BH.Modals.Base
  @include BH.Modules.I18n

  className: 'mailing_list_view'
  template: BH.Templates['mailing_list']

  events:
    'click .close': 'closeClicked'
    'click #join_mailing_list': 'joinMailingListClicked'

  initialize: ->
    @chromeAPI = chrome
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  closeClicked: (ev) ->
    ev.preventDefault()
    @close()

  joinMailingListClicked: ->
    @close()

  getI18nValues: ->
    @t [
      'close_button'
      'mailing_list_title'
      'mailing_list_description'
      'mailing_list_link'
      'mailing_list_promise'
      'leave_a_review'
    ]
