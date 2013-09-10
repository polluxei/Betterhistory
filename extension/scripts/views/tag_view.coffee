class BH.Views.TagView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Url

  className: 'tag_view with_controls'

  template: BH.Templates['tag']

  events:
    'click .delete_sites': 'onDeleteSitesClicked'
    'click .rename': 'onRenameClicked'

  initialize: ->
    @chromeAPI = chrome
    @model.on 'change', @onSitesLoaded, @
    @model.on 'change:name', @onNameChange, @

  pageTitle: ->
    @t('collection_title', [@options.name])

  render: ->
    properties = _.extend @getI18nValues(), collectionsUrl: '#tags'
    html = Mustache.to_html @template, properties
    @$el.append html
    @

  onSitesLoaded: ->
    @renderTaggedSites()

  onNameChange: ->
    router.navigate @urlFor('tag', @model.get('name')),
      trigger: true

  renderTaggedSites: ->
    @taggedSitesView.remove() if @taggedSitesView
    @taggedSitesView = new BH.Views.TaggedSitesView
      model: @model
    @$('.content').html @taggedSitesView.render().el

  onDeleteSitesClicked: (ev) ->
    @promptToDeleteAllSites()

  onRenameClicked: (ev) ->
    ev.preventDefault()
    renameTagView = new BH.Views.RenameTagView
      model: @model
    $('body').append(renameTagView.render().el)
    renameTagView.open()

  promptToDeleteAllSites: ->
    promptMessage = @t('confirm_delete_all_sites_in_collection', [@options.name])
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      @model.destroy =>
      @promptView.close()
      router.navigate '#tags', trigger: true
    else
      @promptView.close()

  getI18nValues: ->
    name = @options.name.charAt(0).toUpperCase() + @options.name.slice(1)
    properties = @t ['delete_all_sites_in_collection', 'search_input_placeholder_text', 'rename_tag_link']
    properties['i18n_collection_title'] = @t 'collection_title', [name]
    properties['i18n_back_to_collections_link'] = @t('back_to_collections_link', [
      @t('back_arrow')
    ])
    properties
