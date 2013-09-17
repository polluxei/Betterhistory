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
      $('.menu .tags').addClass('pulse')

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

    handleDragEnd = (ev) =>
      $el = $(ev.currentTarget)
      $el.removeClass 'dragging'
      $('.menu .tags').removeClass('pulse')

    handleDragEnter = (ev) =>
      $el = $(ev.currentTarget)
      $el.addClass('over')

    handleDragLeave = (ev) =>
      $el = $(ev.currentTarget)
      $el.removeClass('over')

    handleDrop = (ev) =>
      $el = $(ev.currentTarget)
      ev.stopPropagation()

      if $('body .tag_visit_view').length == 0
        @tracker.siteTagDrop()
        $el.removeClass('over')
        data = JSON.parse(ev.dataTransfer.getData('application/json'))

        persistence = new BH.Persistence.Tag
          localStore: localStore

        collection = new BH.Collections.Sites data.sites,
          chrome: chrome
          persistence: persistence

        tagVisitView = new BH.Views.TagVisitView
          collection: collection
        $('body').append tagVisitView.render().el

        collection.fetch()

        tagVisitView.on 'open', =>
          @tracker.droppedTagModalVisible()

        tagVisitView.on 'close', ->
          for site in @collection.toJSON()
            activeTagsView = new BH.Views.ActiveTagsView
              model: new BH.Models.Site(site)
              editable: false
            $container = $("[data-id=#{site.id}]")
            $container.find('.active_tags').html activeTagsView.render().el
            $container.addClass('fade_out')

          $parentVisit = $("[data-id=#{@collection.at(0).id}").parents('.visit')
          if $parentVisit.length > 0
            # Are we dealing with all the children tags?
            if @collection.length == $parentVisit.find('.site').length
              activeTagsView = new BH.Views.ActiveTagsView
                model: new BH.Models.Site(tags: @collection.sharedTags())
                editable: false
              $parentVisit.find('.active_tags').eq(0).html activeTagsView.render().el


        tagVisitView.open()

    handleDragOver = (ev) =>
      ev.preventDefault()
      ev.dataTransfer.effect = 'move'
      false

    $('.visit').each (i, visit) ->
      visit.addEventListener('dragstart', handleDragStart, false)
      visit.addEventListener('dragend', handleDragEnd, false)

    $dropZone = $('.menu .tags')[0]
    $dropZone.addEventListener('dragenter', handleDragEnter, false)
    $dropZone.addEventListener('dragleave', handleDragLeave, false)
    $dropZone.addEventListener('dragover', handleDragOver, false)
    $dropZone.addEventListener('drop', handleDrop, false)

