class BH.Views.SyncingDecisionView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'syncing_decision_view'
  template: BH.Templates['syncing_decision']

  events:
    'click .push': 'pushClicked'
    'click .pull': 'pullClicked'
    'click .continue': 'continueClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    return this

  pushClicked: (ev) ->
    ev.preventDefault()
    @trigger 'decision', 'push'
    @syncing()

  pullClicked: (ev) ->
    ev.preventDefault()
    @trigger 'decision', 'pull'
    @syncing()

  continueClicked: (ev) ->
    ev.preventDefault()
    @close()
    # refresh views for sync tags
    window.location.reload()

  syncing: ->
    @$('.decision').hide()
    @$('.syncing').show()

  doneSyncing: ->
    @$('.continue').removeAttr('disabled')
    @$('.syncing').hide()
    @$('.done_syncing').show()
    @$('.website_plug').show()
    @$('.continue').show()
    @trigger('syncingComplete')

  getI18nValues: ->
    properties = @t ['syncing_decision_title', 'syncing_push_button', 'syncing_pull_button', 'continue_button', 'initial_syncing_description']
    properties.i18n_syncing_decision_description = @t 'syncing_decision_description', [
      @model.get('numberOfSites'),
      '<strong>',
      '</strong>'
    ]
    properties.i18n_initial_syncing_done = @t 'initial_syncing_done', [
      '<a href="http://www.better-history.com/me">',
      '</a>'
    ]
    properties
