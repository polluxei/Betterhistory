class BH.Views.AutocompleteTagsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['autocomplete_tags']

  events:
    'click .delete': 'deleteTagClicked'
    'click .tag': 'tagClicked'
    'keyup input.new_tag': 'newTagChanged'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @collection.on 'reset', @render, @
    @model.on 'change:tags', @renderActiveTags, @

  render: ->
    properties = _.extend @getI18nValues(), {tags: @model.tags()}
    html = Mustache.to_html(@template, properties)
    @$el.html html

    @renderSuggestionsView()
    @renderActiveTags()

    setTimeout ->
      @$('input.new_tag').focus()
    , 0
    @

  renderSuggestionsView: ->
    @suggestionsView = new BH.Views.SuggestionsView
      collection: new Backbone.Collection(@collection.toJSON())
      disqualifiedTags: @model.tags()

    $('.suggestions').html @suggestionsView.render().el

    @suggestionsView.on 'click:tag', (tag) =>
      @attemptToAddTag(tag)
    , @

  renderActiveTags: ->
    activeTagsView = new BH.Views.ActiveTagsView
      model: @model
      editable: true
    @$('.active_tags').html activeTagsView.render().el

  newTagChanged: (ev) ->
    ev.preventDefault()
    @previousEnteredTag ||= ''
    $input = $(ev.currentTarget)
    enteredTag = $input.val()

    if ev.keyCode == 8 && enteredTag.length == 0 && @previousEnteredTag.length == 0
      $tags = $('ul.tags')
      if $tags.length > 0
        $tag = $tags.find('li:not(.input)').last()
        if $tag
          tag = $tag.find('a.tag').data('tag')
          @model.removeTag tag
          @suggestionsView.requalifyTag(tag)
          $tag.remove()
    else
      if enteredTag.length <= 1
        @suggestionsView.hide()
      else
        @suggestionsView.show()

        if ev.keyCode == 40
          @suggestionsView.moveDown()
          $input.val @suggestionsView.selectedTag()
          @previousEnteredTag = enteredTag

        else if ev.keyCode == 38
          @suggestionsView.moveUp()
          $input.val @suggestionsView.selectedTag()
          @previousEnteredTag = enteredTag

        else if ev.keyCode == 13
          tag = @suggestionsView.selectedTag() || enteredTag
          @attemptToAddTag(tag)
        else
          @suggestionsView.filterBy enteredTag
          @previousEnteredTag = enteredTag

  attemptToAddTag: (tag) ->
    if @model.addTag(tag)
      # make sure the added tag does not appear in suggestions
      @suggestionsView.disqualifyTag tag
    else
      # Assume the tag is already in use
      $usedTag = @$(".active_tags [data-tag='#{tag}']")
      $usedTag.addClass 'glow'
      setTimeout (-> $usedTag.removeClass('glow')), 1000

    @$('.new_tag').val ''
    @suggestionsView.hide()
    @previousEnteredTag = ''

  getI18nValues: ->
    @t ['add_a_tag_placeholder']
