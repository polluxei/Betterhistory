class BH.Views.DragAndTagView extends Backbone.View
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

      if $('body .tag_visit_view').length == 0
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
        tagVisitView.open()
        tagVisitView.onDone = (tags) ->
          activeTagsView = new BH.Views.ActiveTagsView
            model: new Backbone.Model(tags: tags)
            editable: false
          $container = $("[data-id=#{data.id}] .active_tags")
          $container.html activeTagsView.render().el

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

