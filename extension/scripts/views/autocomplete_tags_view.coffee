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

  render: ->
    properties = _.extend @getI18nValues(), {tags: @model.tags()}
    html = Mustache.to_html(@template, properties)
    @$el.html html
    setTimeout ->
      @$('input.new_tag').focus()
    , 0
    @

  newTagChanged: (ev) ->
    @previousEnteredTag ||= ''
    $input = $(ev.currentTarget)
    enteredTag = $input.val()
    if ev.keyCode == 8 && enteredTag.length == 0 && @previousEnteredTag.length == 0
      $tags = $('ul.tags')
      if $tags.length > 0
        $tag = $tags.find('li:not(.input)').last()
        if $tag
          @model.removeTag $tag.find('a.tag').data('tag')
          $tag.remove()
    else
      if enteredTag.length >= 2
        $suggestions = @$('.suggestions')
        if ev.keyCode == 40
          if $suggestions.find('.selected').length > 0
            index = $suggestions.find('.selected').index()
            if index != $suggestions.find('li').length
              $suggestions.find('.selected').removeClass('selected')
              $selected = $suggestions.find('li').eq(index + 1)
              $selected.addClass('selected')
              $input.val $selected.data('tag')
          else
            $selected = $suggestions.find('li:first-child')
            $selected.addClass('selected')
            $input.val $selected.data('tag')

        else if ev.keyCode == 38
          if $suggestions.find('.selected').length > 0
            index = $suggestions.find('.selected').index()
            if index != 0
              $suggestions.find('.selected').removeClass('selected')
              $selected = $suggestions.find('li').eq(index - 1)
              $selected.addClass('selected')
              $input.val $selected.data('tag')

        else if ev.keyCode == 13
          $selectedTag = $suggestions.find('.selected')
          if $selectedTag.length > 0
            @model.addTag $selectedTag.data('tag')
          else
            @model.addTag enteredTag

        else
          $suggestions.find('.selected').removeClass('selected')
          matches = []
          @collection.each (tag) =>
            name = tag.get('name')
            if name.match(enteredTag)
              matches.push("<li data-tag='#{name}'>#{name}</li>")
            if matches.length > 0
              $suggestions.html(matches.join(''))
              $suggestions.removeClass('hide')
            else
              $suggestions.addClass('hide')
            $suggestions.find('li').click (ev) =>
              @model.addTag $(ev.currentTarget).data('tag')

    @previousEnteredTag = enteredTag

  deleteTagClicked: (ev) ->
    ev.preventDefault()
    @model.removeTag $(ev.currentTarget).data('tag')
    @tracker.removeTagPopup()

  tagClicked: (ev) ->
    ev.preventDefault()
    tag = $(ev.currentTarget).data('tag')
    @tracker.tagPopupClick()
    @chromeAPI.tabs.create
      url: "chrome://history#tags/#{tag}"

  getI18nValues: ->
    @t ['add_a_tag_placeholder']
