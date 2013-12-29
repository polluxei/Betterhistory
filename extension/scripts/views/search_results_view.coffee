class BH.Views.SearchResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['search_results']

  events:
    'click .delete_visit': 'deleteClicked'

  render: ->
    [start, end] = BH.Lib.Pagination.calculateBounds(@options.page)
    presenter = new BH.Presenters.SearchHistoryPresenter(@collection.toJSON(), @options.query)
    properties = _.extend @getI18nValues(), visits: presenter.history(start, end)
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  insertTags: ->
    persistence.tag().cached (operations) ->
      $('.site').each ->
        $el = $(this)
        tags = operations.siteTags $el.attr('href')
        activeTagsView = new BH.Views.ActiveTagsView
          model: new BH.Models.Site(tags: tags)
          editable: false
        $el.find('.active_tags').html activeTagsView.render().el

  attachDragging: ->
    dragAndTagView = new BH.Views.DragAndTagView
      model: @model
    dragAndTagView.render()

    dragAndTagView.on 'site:change', (site) ->
      activeTagsView = new BH.Views.ActiveTagsView
        model: new BH.Models.Site(site)
        editable: false
      $el = $(".visit[data-url='#{site.url}']")
      $el.find('.active_tags').html activeTagsView.render().el

  deleteClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    new BH.Chrome.History().deleteUrl $el.data('url'), ->
      $el.parents('.visit').remove()

  getI18nValues: ->
    @t ['no_visits_found']
