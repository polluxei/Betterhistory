class BH.Views.AvailableTagsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['available_tags']

  initialize: ->
    @tracker = analyticsTracker
    @draggedSites = @options.draggedSites
    @collection.on 'reset', @render, @

  render: ->
    presenter = new BH.Presenters.TagsPresenter(@collection)
    tags = presenter.selectedAndUnselectedTagsforSites(@draggedSites)
    html = Mustache.to_html @template, tags: tags
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
      for site in collection.toJSON()
        @tracker.siteUntagged()
        @trigger 'site:untagged', site

      if collection.length > 1 || collection.at(0).get('partOfGroup')
        @trigger 'sites:untagged',
          domain: collection.at(0).get('url').match(/\w+:\/\/(.*?)\//)[0]
          tags: _.intersection.apply(_, collection.pluck('tags'))

  tagSites: (tag, collection) ->
    collection.addTag tag, (result, operations) =>
      for site in collection.toJSON()
        @tracker.siteTagged()
        @trigger 'site:tagged', site

      if collection.length > 1 || collection.at(0).get('partOfGroup')
        @trigger 'sites:tagged',
          domain: collection.at(0).get('url').match(/\w+:\/\/(.*?)\//)[0]
          tags: _.intersection.apply(_, collection.pluck('tags'))

      @tracker.tagAdded() if operations.tagCreated

  inflateDraggedData: (data) ->
    sites = JSON.parse(data).sites
    new BH.Collections.Sites sites,
      chrome: chrome
