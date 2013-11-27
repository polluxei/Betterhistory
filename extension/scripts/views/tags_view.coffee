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
    user.on 'login', @onLoggedIn, @
    user.on 'logout', @onLoggedOut, @

  pageTitle: ->
    @t('tags_title')

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.append html
    @

  onBuyTagSyncingClicked: (ev) ->
    ev.preventDefault()
    signUpInfoView = new BH.Views.SignUpInfoView()
    signUpInfoView.open()

  onTagsLoaded: ->
    tag_count = @t 'number_of_tags', [@collection.length]
    @$('.tag_count').text tag_count
    @renderTags()

  onLoggedIn: ->
    @$('.sync_promo').hide()
    @$('.sync_enabled').show()

  onLoggedOut: ->
    @$('.sync_promo').show()
    @$('.sync_enabled').hide()

  onLoadExampleTagsClicked: (ev) ->
    ev.preventDefault()
    exampleTags = new BH.Lib.ExampleTags()
    exampleTags.load =>
      @collection.fetch()

  renderTags: ->
    @tagsListView.remove() if @tagsListView
    @tagsListView = new BH.Views.TagsListView
      collection: @collection
    @$('.content').html @tagsListView.render().el
    @onLoggedIn() if user.get('authId')

  onDismissInstructionsClicked: (ev) ->
    ev.preventDefault()
    syncStore.set tagInstructionsDismissed: true
    $('.about_tags').hide()

  onSignInClicked: (ev) ->
    ev.preventDefault()
    userProcessor = new BH.Lib.UserProcessor()
    userProcessor.start()

  onHowToTagClicked: (ev) ->
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

        if user.isLoggedIn()
          persistence.remote().deleteSites()

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
