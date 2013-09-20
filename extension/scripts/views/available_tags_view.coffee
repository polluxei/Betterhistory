class BH.Views.AvailableTagsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['available_tags']

  initialize: ->
    @tracker = analyticsTracker
    @draggedSites = @options.draggedSites

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
            tagName = prompt('Enter new tag name')
            return unless tagName?
          else
            tagName = $el.data('tag')

          if $el.hasClass('tagged')
            collection.removeTag tagName, =>
              collection.each =>
                @tracker.siteUntagged()
              @rerenderTags(collection)
          else
            collection.addTag tagName, (result, operations) =>
              collection.each =>
                @tracker.siteTagged()
              @tracker.tagAdded() if operations.tagCreated
              @rerenderTags(collection)
        false
      , false)

    @

  inflateDraggedData: (data) ->
    sites = JSON.parse(data).sites
    persistence = new BH.Persistence.Tag(localStore: localStore)

    new BH.Collections.Sites sites,
      chrome: chrome
      persistence: persistence

  rerenderTags: (collection) ->
    for site in collection.toJSON()
      activeTagsView = new BH.Views.ActiveTagsView
        model: new BH.Models.Site(site)
        editable: false
      $container = $("[data-id=#{site.id}]")
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
