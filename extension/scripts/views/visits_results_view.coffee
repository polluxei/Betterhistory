class BH.Views.VisitsResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['visits_results']

  events:
    'click .delete_hour': 'deleteHourClicked'
    'click .delete_visit': 'deleteVisitClicked'
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
        hours: [
          {label: 12, enabled: hours['0'], value: '0'}
          {label: 1, enabled: hours['1'], value: '1'}
          {label: 2, enabled: hours['2'], value:'2'}
          {label: 3, enabled: hours['3'], value: '3'}
          {label: 4, enabled: hours['4'], value: '4'}
          {label: 5, enabled: hours['5'], value: '5'}
          {label: 6, enabled: hours['6'], value: '6'}
          {label: 7, enabled: hours['7'], value: '7'}
          {label: 8, enabled: hours['8'], value: '8'}
          {label: 9, enabled: hours['9'], value: '9'}
          {label: 10, enabled: hours['10'], value: '10'}
          {label: 11, enabled: hours['11'], value: '11'}
          {label: 12, enabled: hours['12'], value: '12'}
          {label: 1, enabled: hours['13'], value: '13'}
          {label: 2, enabled: hours['14'], value: '14'}
          {label: 3, enabled: hours['15'], value: '15'}
          {label: 4, enabled: hours['16'], value: '16'}
          {label: 5, enabled: hours['17'], value: '17'}
          {label: 6, enabled: hours['18'], value: '18'}
          {label: 7, enabled: hours['19'], value: '19'}
          {label: 8, enabled: hours['20'], value: '20'}
          {label: 9, enabled: hours['21'], value: '21'}
          {label: 10, enabled: hours['22'], value: '22'}
          {label: 11, enabled: hours['23'], value: '23'}
        ].reverse()

    html = Mustache.to_html @template, properties

    @$el.html html

    @show()
    @insertTags()
    @attachDragging()
    @inflateDates()


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
    setTimeout (=> @$('.visits_content').html ''), 250

  show: ->
    @$el.removeClass('disappear')

  hide: ->
    @$el.addClass('disappear')

  inflateDates: ->
    $('.time').each (i, el) =>
      timestamp = @collection.at(i).get('lastVisitTime')
      $(el).text new Date(timestamp).toLocaleTimeString(BH.lang)

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
    window.analyticsTracker.hourClick()

    el = $($(ev.currentTarget).attr('href'))[0]
    document.body.scrollTop = el.getBoundingClientRect().top + document.body.scrollTop - 155

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
      analyticsTracker.dayVisitsDeletion()
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
