class BH.Views.InitialSyncingView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'initial_syncing_view'
  template: BH.Templates['initial_syncing']

  events:
    'click .continue': 'continueClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    @tracker.syncAutomaticModalSeen()
    return this

  continueClicked: (ev) ->
    ev.preventDefault()
    @close()
    # refresh views for sync tags
    window.location.reload()

  doneSyncing: ->
    @$('.continue').removeAttr('disabled')
    @$('.syncing').hide()
    @$('.done_syncing').show()
    @$('.website_plug').show()
    @$('.title').remove()
    @$('.content-area').css marginTop: 26
    @trigger('syncingComplete')

  getI18nValues: ->
    properties = @t ['initial_syncing_title', 'continue_button', 'initial_syncing_description']
    properties.i18n_initial_syncing_done = @t 'initial_syncing_done', [
      '<a href="http://www.better-history.com/me">',
      '</a>'
    ]
    properties
