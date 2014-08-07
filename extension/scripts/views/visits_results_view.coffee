class BH.Views.VisitsResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['visits_results']

  events:
    'click .delete_all': 'deleteAllClicked'
    'click .delete_visit': 'deleteVisitClicked'
    'click .visit > a': 'visitClicked'

  initialize: ->
    @chromeAPI = chrome

  render: ->
    properties = @getI18nValues()

    if @collection.length > 0
      properties.history =
        visits: @collection.toJSON()
        date: @model.get('date').toLocaleDateString('en')

    html = Mustache.to_html @template, properties

    @$el.html html

    @show()
    @insertTags()
    @attachDragging()
    @inflateDates()

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

  deleteAllClicked: (ev) ->
    ev.preventDefault()
    @promptToDeleteAllVisits()

  deleteVisitClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    analyticsTracker.visitDeletion()
    new BH.Chrome.History().deleteUrl $el.data('url'), =>
      $el.parent('.visit').remove()

  promptToDeleteAllVisits: ->
    timestamp = @model.get('date').toLocaleDateString(BH.lang)
    promptMessage = @t 'confirm_delete_all_visits', [timestamp]
    @promptView = BH.Views.CreatePrompt(promptMessage)
    @promptView.open()
    @promptView.model.on('change', @promptAction, @)

  promptAction: (prompt) ->
    if prompt.get('action')
      analyticsTracker.dayVisitsDeletion()
      new BH.Lib.VisitsHistory(@model.get('date')).destroy ->
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
