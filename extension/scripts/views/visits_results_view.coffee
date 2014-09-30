class BH.Views.VisitsResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['visits_results']

  events:
    'click .download': 'downloadClicked'
    'click .delete_hour': 'deleteHourClicked'
    'click .delete_visit': 'deleteVisitClicked'
    'click .delete_download': 'deleteDownloadClicked'
    'click .visit > a': 'visitClicked'
    'click .hours a': 'hourClicked'

  initialize: ->
    @chromeAPI = chrome

  render: ->
    properties = @getI18nValues()
    presenter = new BH.Presenters.VisitsPresenter()
    visitsByHour = presenter.visitsByHour(@collection.toJSON())
    hours = presenter.hoursDistribution(@collection.toJSON())

    if @collection.length > 0
      date = @model.get('date')
      properties.history =
        visitsByHour: visitsByHour.reverse()
        date: date.toLocaleDateString('en')
        day: moment(date).format('dddd')
        hours: hours

    html = Mustache.to_html @template, properties

    @$el.html html

    document.body.scrollTop = 0

    @show()
    @insertTags()
    @attachDragging()
    @inflateDates()
    @inflateDownloadIcons()

    # Mark first available hour as selected
    @$('.controls.hours a:not(.disabled)').eq(0).addClass('selected')

    window.analyticsTracker.dayActivityDownloadCount(@$('.visits a.download').length)
    window.analyticsTracker.dayActivityVisitCount(@$('.visits a.site').length)


    lastId = null
    topMenu = @$('.hours')
    topMenuHeight = topMenu.outerHeight()
    menuItems = topMenu.find("a")
    scrollItems = menuItems.map -> $($(this).attr("href"))

    $(window).scroll ->

      # Get container scroll position
      fromTop = document.body.scrollTop

      # Get id of current scroll item
      cur = []
      scrollItems.map (el) ->
        offsetTop = el.getBoundingClientRect().top + document.body.scrollTop - 205
        cur.push el if offsetTop < fromTop

      # Get the id of the current element
      id = cur[cur.length - 1]?.id
      if lastId isnt id
        lastId = id

        # Set/remove active class
        menuItems.removeClass("selected")
        menuItems.filter("[href='##{id}']").addClass "selected"
      return

    @

  resetRender: ->
    @hide()
    @$('.visits_content').html ''

  show: ->
    @$el.removeClass('disappear')

  hide: ->
    @$el.addClass('disappear')

  inflateDates: ->
    $('.time').each (i, el) =>
      model = @collection.at(i)
      timestamp = model.get('lastVisitTime') || model.get('startTime')
      $(el).text new Date(timestamp).toLocaleTimeString(BH.lang)

  inflateDownloadIcons: ->
    callback = (el, uri) ->
      $(el).find('.description').css backgroundImage: "url(#{uri})"

    $('.download').each (i, el) =>
      downloadId = parseInt($(el).data('download-id'), 10)
      chrome.downloads.getFileIcon downloadId, {}, (uri) ->
        callback(el, uri)

  insertTags: ->
    persistence.tag().cached (operations) ->
      $('.site').each ->
        $el = $(this)
        tags = operations.siteTags $el.attr('href')
        if tags.length > 0
          activeTagsView = new BH.Views.ActiveTagsView
            model: new BH.Models.Site(tags: tags)
            editable: false
          $el.find('.active_tags').html activeTagsView.render().el

      $('.grouped_sites').each (i, siteEl) =>
        $el = $(siteEl)
        urls = []
        $el.find('a.site').each -> urls.push($(this).attr('href'))
        sharedTags = operations.sitesTags urls
        activeTagsView = new BH.Views.ActiveTagsView
          model: new BH.Models.Site(tags: sharedTags)
          editable: false
        $el.find('.active_tags').eq(0).html activeTagsView.render().el

  attachDragging: ->
    dragAndTagView = new BH.Views.DragAndTagView
      collection: @collection
    dragAndTagView.render()

    dragAndTagView.on 'site:change', (site, $el) ->
      activeTagsView = new BH.Views.ActiveTagsView
        model: new BH.Models.Site(site)
        editable: false
      $el.find('.active_tags').html activeTagsView.render().el

    dragAndTagView.on 'sites:change', (site, $el) ->
      activeTagsView = new BH.Views.ActiveTagsView
        model: new BH.Models.Site(site)
        editable: false
      $activeTags = $el.children('.sites').find('.active_tags')
      $activeTags.html activeTagsView.render().el

  visitClicked: (ev) ->
    if $(ev.target).hasClass('search_domain')
      ev.preventDefault()
      router.navigate($(ev.target).attr('href'), trigger: true)

  hourClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)

    window.analyticsTracker.hourClick($el.data('hour'))

    $hour = $($el.attr('href'))[0]

    document.body.scrollTop = $hour.getBoundingClientRect().top + document.body.scrollTop - 155

  downloadClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    downloadId = parseInt $el.data('download-id'), 10
    chrome.downloads.show downloadId

  deleteHourClicked: (ev) ->
    ev.preventDefault()
    hour = $(ev.currentTarget).data('hour')
    @promptToDeleteHour(hour)

  deleteVisitClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    analyticsTracker.visitDeletion()
    Historian.deleteUrl $el.data('url'), =>
      $el.parent('.visit').remove()

  deleteDownloadClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    analyticsTracker.downloadDeletion()
    Historian.deleteDownload $el.data('url'), =>
      $el.parent('.visit').remove()

  promptToDeleteHour: (hour) ->
    date = new Date(@model.get('date'))
    date.setHours(hour)
    date.setSeconds(0)
    date.setMinutes(0)
    timestamp = date.toLocaleString(BH.lang)
    promptMessage = @t 'confirm_delete_all_visits', [timestamp]
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on 'change', (prompt) =>
      @promptAction(prompt, hour)
    , @

  promptAction: (prompt, hour) ->
    if prompt.get('action')
      window.analyticsTracker.hourDeletion()
      dayHistorian = new Historian.Day(@model.get('date'))
      dayHistorian.destroyHour hour, ->
        window.location.reload()
    else
      @promptView.close()

  getI18nValues: ->
    @t [
      'prompt_delete_button'
      'delete_time_interval_button'
      'no_visits_found'
      'expand_button'
      'collapse_button'
      'search_by_domain'
      'delete_all_visits_for_filter_button'
    ]
