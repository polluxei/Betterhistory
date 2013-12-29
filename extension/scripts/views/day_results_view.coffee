class BH.Views.DayResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['day_results']

  events:
    'click .delete_visit': 'deleteVisitClicked'
    'click .delete_grouped_visit': 'deleteGroupedVisitClicked'
    'click .delete_interval': 'deleteIntervalClicked'
    'click .show_visits': 'toggleGroupedVisitsClicked'
    'click .hide_visits': 'toggleGroupedVisitsClicked'
    'click .visit > a': 'visitClicked'

  initialize: ->
    @chromeAPI = chrome

  render: ->
    presenter = new BH.Presenters.DayHistoryPresenter(@collection.toJSON())
    properties = _.extend @getI18nValues(), history: presenter.history(), readOnly: state.get('readOnly')
    html = Mustache.to_html @template, properties
    @$el.html html

    @

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

    dragAndTagView.on 'site:change', (site) ->
      activeTagsView = new BH.Views.ActiveTagsView
        model: new BH.Models.Site(site)
        editable: false
      $el = $(".visit[data-url='#{site.url}']")
      $el.find('.active_tags').html activeTagsView.render().el

  visitClicked: (ev) ->
    if $(ev.target).hasClass('search_domain')
      ev.preventDefault()
      router.navigate($(ev.target).attr('href'), trigger: true)

  deleteVisitClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    analyticsTracker.visitDeletion()
    new BH.Chrome.History().deleteUrl $el.data('url'), ->
      $el.parent('.visit').remove()

  deleteGroupedVisitClicked: (ev) ->
    ev.preventDefault()
    ev.stopPropagation()
    analyticsTracker.groupedVisitsDeletion()
    $(ev.currentTarget).siblings('.visits').children().each (i, visit) ->
      $(visit).find('.delete_visit').trigger('click')

    $(ev.currentTarget).parents('.visit').remove()

  deleteIntervalClicked: (ev) ->
    ev.preventDefault()
    analyticsTracker.timeIntervalDeletion()
    visitElements = $(ev.currentTarget).parents('.interval').children('.visits').children()
    $(visitElements).each (i, visit) ->
      setTimeout ->
        $(visit).children('.delete').trigger('click')
      , i * 10

  toggleGroupedVisitsClicked: (ev) ->
    ev.preventDefault()
    $(ev.currentTarget).parents('.visit')
      .toggleClass('expanded')

  getI18nValues: ->
    @t [
      'prompt_delete_button'
      'delete_time_interval_button'
      'no_visits_found'
      'expand_button'
      'collapse_button'
      'search_by_domain'
    ]
