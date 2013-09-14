class BH.Views.DragAndTagView extends Backbone.View
  initialize: ->
    @tracker = analyticsTracker

  render: ->
    handleDragStart = (ev) =>
      ev.stopPropagation()
      $el = $(ev.currentTarget)
      $el.addClass 'dragging'
      $('.menu .tags').addClass('pulse')

      if $el.hasClass('searched')
        history = @model.get('history')
        visit = history.get($el.data('id'))
      else
        intervalId = $el.parents('.interval').data('id')
        interval = @model.get('history').get(intervalId)
        visit = interval.findVisitById($el.data('id'))

      site =
        url: visit.get('url')
        title: visit.get('title')
        id: visit.get('id')

      @tracker.siteTagDrag()

      unless summaryEl = document.getElementsByClassName('drag_ghost')[0]
        summaryEl = document.createElement 'div'
        summaryEl.innerHTML = '1 visit'
        summaryEl.className = 'drag_ghost'
        $('body').append(summaryEl)

      ev.dataTransfer.setDragImage summaryEl, -15, -10
      ev.dataTransfer.setData 'application/json', JSON.stringify(site)

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

        site = new BH.Models.Site data,
          chrome: chrome
          persistence: persistence

        tagVisitView = new BH.Views.TagVisitView
          model: site
        $('body').append tagVisitView.render().el

        site.fetch()
        tagVisitView.open =>
          @tracker.droppedTagModalVisible()

        tagVisitView.onDone = (tags) ->
          $container = $("[data-id=#{data.id}]")
          activeTagsView = new BH.Views.ActiveTagsView
            model: new Backbone.Model(tags: tags)
            editable: false
          $container.find('.active_tags').html activeTagsView.render().el
          $container.addClass('fade_out')

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

