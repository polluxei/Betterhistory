class BH.Views.DragAndTagView extends Backbone.View
  @include BH.Modules.I18n

  initialize: ->
    @tracker = analyticsTracker
    @chromeAPI = chrome

  render: ->
    handleDragStart = (ev) =>
      ev.stopPropagation()
      $el = $(ev.currentTarget)
      $el.addClass 'dragging'
      $('.navigation').addClass('dropzone')

      data = sites: []
      if $el.hasClass('searched')
        count = 1
        history = @model.get('history')
        visit = history.get($el.data('id'))
        data.sites.push
          url: visit.get('url')
          title: visit.get('title')
          id: visit.get('id')
      else
        intervalId = $el.parents('.interval').data('id')
        interval = @model.get('history').get(intervalId)

        if $el.find('ol.visits').length > 0
          count = $el.find('.visits .visit').length
          $el.find('ol.visits .visit').each ->
            visit = interval.findVisitById($(this).data('id'))
            data.sites.push
              url: visit.get('url')
              title: visit.get('title')
              id: visit.get('id')
        else
          visit = interval.findVisitById($el.data('id'))
          count = 1
          data.sites.push
            url: visit.get('url')
            title: visit.get('title')
            id: visit.get('id')


      @tracker.siteTagDrag()

      unless summaryEl = document.getElementsByClassName('drag_ghost')[0]
        summaryEl = document.createElement 'div'
        summaryEl.className = 'drag_ghost'
        $('body').append(summaryEl)
      summaryEl.innerHTML = @t('number_of_visits', [count])

      ev.dataTransfer.setDragImage summaryEl, -15, -10
      ev.dataTransfer.setData 'application/json', JSON.stringify(data)

      collection = new BH.Collections.Tags {},
        persistence: new BH.Persistence.Tag(localStore: localStore)

      availableTagsView = new BH.Views.AvailableTagsView
        collection: collection
        draggedSites: data.sites
        el: '.available_tags'
      collection.fetch()

    handleDragEnd = (ev) =>
      $el = $(ev.currentTarget)
      $el.removeClass 'dragging'
      $('.navigation').removeClass('dropzone')

    $('.visit').each (i, visit) ->
      visit.addEventListener('dragstart', handleDragStart, false)
      visit.addEventListener('dragend', handleDragEnd, false)
