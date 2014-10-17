class BH.Views.TagsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'tags_view with_controls'

  template: BH.Templates['tags']

  events:
    'click .delete_all': 'onDeleteTagsClicked'
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @collection.on 'reset', @onTagsLoaded, @

  pageTitle: ->
    @t('tags_title')

  render: ->
    properties = _.extend @getI18nValues()
    html = Mustache.to_html @template, properties
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
    properties = @t ['tags_title', 'search_input_placeholder_text', 'delete_all_tags', 'how_to_tag', 'read_only_explanation_link']
    properties.i18n_sync_tags_link = @t 'sync_tags_link', [
      '<a style="text-decoration: underline;" href="#" id="sign_up">',
      '</a>',
      '<a style="text-decoration: underline;" href="#" id="sign_in">',
      '</a>'
    ]
    properties.i18n_sync_enabled = @t 'sync_enabled', ['<span class="inline-tag">', '</span>']
    properties
