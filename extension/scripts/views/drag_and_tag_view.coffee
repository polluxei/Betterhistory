class BH.Views.DragAndTagView extends Backbone.View
  @include BH.Modules.I18n

  initialize: ->
    @tracker = analyticsTracker
    @chromeAPI = chrome
    @excludeTag = @options.excludeTag

  render: ->
    handleDragStart = (ev) =>
      ev.stopPropagation()
      $el = $(ev.currentTarget)
      $el.addClass 'dragging'
      $('.navigation').addClass('dropzone')

      data = sites: []
      if $el.find('ol.visits').length > 0
        $el.find('ol.visits .visit').each ->
          data.sites.push
            url: $(this).data('url')
            title: $(this).get('title')
            datetime: new Date().getTime()
      else
        data.sites.push
          url: $el.data('url')
          title: $el.data('title')
          datetime: new Date().getTime()

      @tracker.siteTagDrag()

      unless summaryEl = document.getElementsByClassName('drag_ghost')[0]
        summaryEl = document.createElement 'div'
        summaryEl.className = 'drag_ghost'
        $('body').append(summaryEl)
      summaryEl.innerHTML = @t('number_of_visits', [data.sites.length])

      ev.dataTransfer.setDragImage summaryEl, -15, -10
      ev.dataTransfer.setData 'application/json', JSON.stringify(data)

      collection = new BH.Collections.Tags []

      availableTagsView = new BH.Views.AvailableTagsView
        collection: collection
        draggedSites: data.sites
        el: '.available_tags'

      availableTagsView.on 'site:untagged', (site) =>
        @trigger 'site:change', site

      availableTagsView.on 'site:tagged', (site) =>
        @trigger 'site:change', site

      availableTagsView.on 'sites:untagged', (site) =>
        @trigger 'sites:change', site

      availableTagsView.on 'sites:tagged', (site) =>
        @trigger 'sites:change', site

      collection.fetch()

    handleDragEnd = (ev) =>
      $el = $(ev.currentTarget)
      $el.removeClass 'dragging'
      $('.navigation').removeClass('dropzone')

    $('.visit').each (i, visit) ->
      visit.addEventListener('dragstart', handleDragStart, false)
      visit.addEventListener('dragend', handleDragEnd, false)
