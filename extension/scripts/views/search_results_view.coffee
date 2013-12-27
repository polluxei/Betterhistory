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

  deleteClicked: (ev) ->
    ev.preventDefault()
    model = @_getModelFromElement($(ev.target))
    model.destroy
      success: => @_getElementFromModel(model).remove()

  _getModelFromElement: (element) ->
    history = @model.get('history')
    history.get($(element).prev().data('id'))

  _getElementFromModel: (model) ->
    $("[data-id='#{model.id}']").parents('li')

  getI18nValues: ->
    @t ['no_visits_found']
