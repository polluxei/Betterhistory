class BH.Views.TagsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'tags_view with_controls'

  template: BH.Templates['tags']

  events:
    'click .delete_all': 'onDeleteTagsClicked'
    'click .how_to_tag': 'onHowToTagClicked'
    'click .dismiss_instructions': 'onDismissInstructionsClicked'
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

  onTagsLoaded: ->
    tag_count = @t 'number_of_tags', [@collection.length]
    @$('.tag_count').text tag_count
    @renderTags()

  renderTags: ->
    @tagsListView.remove() if @tagsListView
    @tagsListView = new BH.Views.TagsListView
      collection: @collection
    @$('.content').html @tagsListView.render().el

  onDismissInstructionsClicked: (ev) ->
    ev.preventDefault()
    syncStore.set tagInstructionsDismissed: true
    $('.about_tags').hide()

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
      @collection.destroy()
      @collection.fetch()
      @promptView.close()
    else
      @promptView.close()

  getI18nValues: ->
    properties = @t ['tags_title', 'search_input_placeholder_text', 'delete_all_tags', 'how_to_tag']
    properties
