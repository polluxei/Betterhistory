class BH.Views.TagView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Url

  className: 'tag_view with_controls'

  template: BH.Templates['tag']

  events:
    'click .delete_sites': 'onDeleteSitesClicked'
    'click .rename': 'onRenameClicked'
    'click .share': 'onShareClicked'
    'click .read_only_explanation': 'onReadOnlyExplanationClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker

    @model.on 'change', @onSitesLoaded, @
    @model.on 'change:name', @onNameChange, @

    tagState.on 'change:readOnly', @onReadOnlyChange, @
    tagState.on 'synced', @onSynced, @

  pageTitle: ->
    @t('tag_title', [@options.name])

  render: ->
    properties = _.extend @getI18nValues(), {tagsUrl: '#tags'}, tagState.toJSON()
    html = Mustache.to_html @template, properties
    @$el.append html
    @

  onReadOnlyChange: ->
    @$el.html ''
    @render()
    @model.fetch()

  onSynced: ->
    @$el.html ''
    @render()
    @model.fetch()

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
    @taggedSitesView.attachDragging()
    @taggedSitesView.insertTags()

  onReadOnlyExplanationClicked: (ev) ->
    ev.preventDefault()
    readOnlyExplanationModal = new BH.Modals.ReadOnlyExplanationModal()
    readOnlyExplanationModal.open()

  onDeleteSitesClicked: (ev) ->
    @tracker.deleteTagClick()
    @promptToDeleteAllSites()

  onRenameClicked: (ev) ->
    ev.preventDefault()
    @tracker.renameTagClick()
    renameTagModal = new BH.Modals.RenameTagModal
      model: @model
      tracker: @tracker
    $('body').append(renameTagModal.render().el)
    renameTagModal.open()
    $('.new_tag').focus()

  onShareClicked: (ev) ->
    ev.preventDefault()
    @tracker.shareClicked()

    if @model.get('url')
      url = encodeURIComponent(@model.get('url'))
      @chromeAPI.tabs.create url: "http://#{window.siteHost}/from_ext/#{url}"
    else
      $smallSpinner = @$('.small_spinner')

      unless $smallSpinner.hasClass('show')
        $smallSpinner.addClass('show')

        @model.share
          success: (data) =>
            $smallSpinner.removeClass('show')
            url = encodeURIComponent(data.url)
            @chromeAPI.tabs.create url: "http://#{window.siteHost}/from_ext/#{url}"
            @model.set(url: data.url)
          error: =>
            $smallSpinner.removeClass('show')
            alert('There was an error. Please try again later')

  promptToDeleteAllSites: ->
    promptMessage = @t('confirm_delete_tag', [@options.name])
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      tagName = @model.get('name')
      @model.destroy =>
      @promptView.close()
      @tracker.tagRemoved()

      if user.isLoggedIn()
        persistence.remote().deleteTag(tagName)

      router.navigate '#tags', trigger: true
    else
      @promptView.close()

  getI18nValues: ->
    name = @options.name.charAt(0).toUpperCase() + @options.name.slice(1)
    properties = @t ['delete_tag', 'search_input_placeholder_text', 'rename_tag_link', 'share_tag_link', 'read_only_explanation_link']
    properties['i18n_tag_title'] = @t 'tag_title', [name]
    properties['i18n_back_to_tags_link'] = @t('back_to_tags_link', [
      @t('back_arrow')
    ])
    properties
