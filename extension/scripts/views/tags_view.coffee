class BH.Views.TagsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'tags_view with_controls'

  template: BH.Templates['tags']

  events:
    'click .delete_all': 'onDeleteTagsClicked'
    'click .how_to_tag': 'onHowToTagClicked'
    'click .load_example_tags': 'onLoadExampleTagsClicked'
    'click .dismiss_instructions': 'onDismissInstructionsClicked'
    'click #sign_up': 'onBuyTagSyncingClicked'
    'click #sign_in': 'onSignInClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @collection.on 'reset', @onTagsLoaded, @

  pageTitle: ->
    @t('tags_title')

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.append html
    @

  onBuyTagSyncingClicked: ->
    google.payments.inapp.buy
      parameters: {}
      jwt: "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIwNjM4OTg2NDA5NjI5N" +
           "Dc5OTE0OCIsImF1ZCI6Ikdvb2dsZSIsInR5cCI6Imdvb2dsZS9" +
           "wYXltZW50cy9pbmFwcC9pdGVtL3YxIiwiaWF0IjoxMzgzMzIxN" +
           "jQwLCJleHAiOjEzODM0MDgwNDAsInJlcXVlc3QiOnsiY3VycmV" +
           "uY3lDb2RlIjoiVVNEIiwicHJpY2UiOiIxMC4wMCIsIm5hbWUiO" +
           "iJCZXR0ZXIgSGlzdG9yeSIsInNlbGxlckRhdGEiOiJzb21lIG9" +
           "wYXF1ZSBkYXRhIiwiZGVzY3JpcHRpb24iOiJVbmxpbWl0ZWQgd" +
           "GFnIHN5bmNpbmcgKG9uZSB0aW1lIGZlZSkifX0.kOl1AII7iYX" +
           "2R986M6qMxM5gig0EC4nyyB_grcYoyps",
      success: ->
        window.alert('success')
      failure: ->
        window.alert('failure')

  onTagsLoaded: ->
    tag_count = @t 'number_of_tags', [@collection.length]
    @$('.tag_count').text tag_count
    @renderTags()

  onLoadExampleTagsClicked: (ev) ->
    ev.preventDefault()
    persistence = new BH.Persistence.Tag(localStore: localStore)
    exampleTags = new BH.Lib.ExampleTags
      persistence: persistence
      chrome: chrome
      localStore: localStore
    exampleTags.load =>
      @collection.fetch()

  renderTags: ->
    @tagsListView.remove() if @tagsListView
    @tagsListView = new BH.Views.TagsListView
      collection: @collection
    @$('.content').html @tagsListView.render().el

  onDismissInstructionsClicked: (ev) ->
    ev.preventDefault()
    syncStore.set tagInstructionsDismissed: true
    $('.about_tags').hide()

  onSignInClicked: (ev) ->
    ev.preventDefault()

    googleUserInfo = new BH.Lib.GoogleUserInfo(OAuth2)
    googleUserInfo.fetch
      success: =>
        authSuccessfulView = new BH.Views.AuthSuccessfulView()
        authSuccessfulView.open()
        @$('.sync_promo').hide()
        @$('.sync_enabled').show()
      error: ->
        alert('error')

  onHowToTagClicked: (ev) ->
    @tracker.howToTagClick()
    ev.preventDefault()
    howToTagView = new BH.Views.HowToTagView()
    howToTagView.open()

  onDeleteTagsClicked: (ev) ->
    @tracker.deleteAllTagsClick()
    @promptToDeleteTags()

  promptToDeleteTags: ->
    promptMessage = @t('confirm_delete_all_tags')
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      @collection.destroy =>
        @collection.fetch()
      @promptView.close()
    else
      @promptView.close()

  getI18nValues: ->
    properties = @t ['tags_title', 'search_input_placeholder_text', 'delete_all_tags', 'how_to_tag']
    properties.i18n_sync_tags_link = @t 'sync_tags_link', [
      '<a style="text-decoration: underline;" href="#" id="sign_up">',
      '</a>',
      '<a style="text-decoration: underline;" href="#" id="sign_in">',
      '</a>'
    ]
    properties.i18n_sync_enabled = @t 'sync_enabled', ['<span class="inline-tag">', '</span>']
    properties
