class BH.Views.TagView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'tag_view with_controls'

  template: BH.Templates['tag']

  events:
    'click .delete_sites': 'onDeleteSitesClicked'

  initialize: ->
    @chromeAPI = chrome

  pageTitle: ->
    @t('collection_title', [@options.name])

  render: ->
    properties = _.extend @getI18nValues(), collectionsUrl: '#tags'
    html = Mustache.to_html @template, properties
    @$el.append html
    @

  onDeleteSitesClicked: (ev) ->
    @promptToDeleteAllSites()

  promptToDeleteAllSites: ->
    promptMessage = @t('confirm_delete_all_sites_in_collection', [@options.name])
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      track.dayVisitsDeletion()
      @history.destroy()
      @history.fetch
        success: =>
          @promptView.close()
    else
      @promptView.close()

  getI18nValues: ->
    name = @options.name.charAt(0).toUpperCase() + @options.name.slice(1)
    properties = @t ['delete_all_sites_in_collection', 'search_input_placeholder_text']
    properties['i18n_collection_title'] = @t 'collection_title', [name]
    properties['i18n_back_to_collections_link'] = @t('back_to_collections_link', [
      @t('back_arrow')
    ])
    properties
