class BH.Views.TagView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Url

  className: 'tag_view with_controls'

  template: BH.Templates['tag']

  events:
    'click .delete_sites': 'onDeleteSitesClicked'
    'click .rename': 'onRenameClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker

    @model.on 'change', @onSitesLoaded, @
    @model.on 'change:name', @onNameChange, @

  pageTitle: ->
    @t('tag_title', [@options.name])

  render: ->
    properties = _.extend @getI18nValues(), tagsUrl: '#tags'
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
    @tracker.deleteTagClick()
    @promptToDeleteAllSites()

  onRenameClicked: (ev) ->
    ev.preventDefault()
    @tracker.renameTagClick()
    renameTagView = new BH.Views.RenameTagView
      model: @model
    $('body').append(renameTagView.render().el)
    renameTagView.open()
    $('.new_tag').focus()

  promptToDeleteAllSites: ->
    promptMessage = @t('confirm_delete_tag', [@options.name])
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
    properties = @t ['delete_tag', 'search_input_placeholder_text', 'rename_tag_link']
    properties['i18n_tag_title'] = @t 'tag_title', [name]
    properties['i18n_back_to_tags_link'] = @t('back_to_tags_link', [
      @t('back_arrow')
    ])
    properties
