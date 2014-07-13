class BH.Views.SearchResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['search_results']

  events:
    'click .delete_visit': 'deleteClicked'

  initialize: ->
    @page = @options.page

  render: ->
    [start, end] = BH.Lib.Pagination.calculateBounds(@page.get('page') - 1)

    presenter = new BH.Presenters.SearchHistoryPresenter(@collection.toJSON(), @options.query)

    properties = _.extend @getI18nValues(),
      visits: presenter.history(start, end)
      extendSearch: @page.get('totalPages') == @page.get('page')

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

    dragAndTagView.on 'site:change', (site, $el) ->
      activeTagsView = new BH.Views.ActiveTagsView
        model: new BH.Models.Site(site)
        editable: false
      $el.find('.active_tags').html activeTagsView.render().el

  deleteClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    url = $el.data('url')

    new BH.Lib.SearchHistory().deleteUrl url, =>
      $el.parents('.visit').remove()
      @collection.remove @collection.where(url: url)

  getI18nValues: ->
    @t [
      'no_visits_found'
      'prompt_delete_button'
    ]
