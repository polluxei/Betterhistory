class BH.Views.AvailableTagsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['available_tags']

  initialize: ->
    @tracker = analyticsTracker
    @draggedSites = @options.draggedSites
    @excludedTag = @options.excludedTag
    @collection.on 'reset', @render, @

  render: ->
    presenter = new BH.Presenters.TagsPresenter(@collection)
    properties = presenter.selectedAndUnselectedTagsforSites(@draggedSites)
    html = Mustache.to_html @template, properties
    @$el.html html

    $('.available_tags li').each (i, tag) =>
      tag.addEventListener('dragenter', (ev) ->
        $(ev.currentTarget).addClass 'over'
      , false)

      tag.addEventListener('dragleave', (ev) ->
        $(ev.currentTarget).removeClass 'over'
      , false)

      tag.addEventListener('dragover', (ev) ->
        ev.preventDefault()
        ev.dataTransfer.effect = 'move'
      , false)

      tag.addEventListener('drop', (ev) =>
        $el = $(ev.currentTarget)
        ev.stopPropagation()

        @tracker.siteTagDrop()

        draggedData = ev.dataTransfer.getData('application/json')
        collection = @inflateDraggedData(draggedData)
        collection.fetch()
        collection.on 'reset:allTags', =>
          if $el.hasClass('new_tag')
            @renderNewTagView(collection)
          else
            tagName = $el.data('tag')

          if $el.hasClass('tagged')
            @untagSites tagName, collection
          else
            @tagSites tagName, collection
        false
      , false)

    @

  renderNewTagView: (collection) ->
    newTagModal = new BH.Modals.NewTagModal
      model: new BH.Models.Tag()
      tracker: @tracker
    $('body').append(newTagModal.render().el)
    newTagModal.open()
    $('.new_tag').focus()
    newTagModal.model.on 'change:name', =>
      @tagSites newTagModal.model.get('name'), collection

  untagSites: (tag, collection) ->
    collection.removeTag tag, =>
      collection.each =>
        @tracker.siteUntagged()
      @rerenderTags(collection)

  tagSites: (tag, collection) ->
    collection.addTag tag, (result, operations) =>
      collection.each =>
        @tracker.siteTagged()
      @tracker.tagAdded() if operations.tagCreated
      @rerenderTags(collection)

  inflateDraggedData: (data) ->
    sites = JSON.parse(data).sites
    new BH.Collections.Sites sites,
      chrome: chrome

  rerenderTags: (collection) ->
    for site in collection.toJSON()

      # check if the tag to exclude in the ui has been remove, because
      # the visit should also disappear then
      if @excludedTag? && site.tags.indexOf(@excludedTag) == -1
        $("[data-id='#{site.id}']").remove()

      site.tags = _.without(site.tags, @excludedTag) if @excludedTag?
      activeTagsView = new BH.Views.ActiveTagsView
        model: new BH.Models.Site(site)
        editable: false
      $container = $("[data-id='#{site.id}']")
      $container.find('.active_tags').html activeTagsView.render().el
      $container.addClass('fade_out')

    $parentVisit = $("[data-id=#{collection.at(0).id}").parents('.visit')
    if $parentVisit.length > 0
      # Are we dealing with all the children tags?
      if collection.length == $parentVisit.find('.site').length
        activeTagsView = new BH.Views.ActiveTagsView
          model: new BH.Models.Site(tags: collection.sharedTags())
          editable: false
        $parentVisit.find('.active_tags').eq(0).html activeTagsView.render().el
