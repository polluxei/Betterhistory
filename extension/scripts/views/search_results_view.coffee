class BH.Views.SearchResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['search_results']

  initialize: ->
    @chromeAPI = chrome

  events:
    'click .delete_visit': 'deleteClicked'

  render: ->
    [start, end] = BH.Lib.Pagination.calculateBounds(@options.page)

    presenter = new BH.Presenters.SearchHistoryPresenter(@model)
    collectionToTemplate = presenter.history(start, end)

    highlightedVisits = for visit in collectionToTemplate.visits
      @markMatches(visit)

    collectionToTemplate.visits = highlightedVisits
    properties = _.extend @getI18nValues(), collectionToTemplate
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

  markMatches: (visit) ->
    regExp = titleMatch = locationMatch = timeMatch = null

    if visit?
      for term in @model.get('query').split(' ')
        regExp = new RegExp(term, "i")
        visit.title = @_wrapMatchInProperty(regExp, visit.title)
        visit.location = @_wrapMatchInProperty(regExp, visit.location)
        visit.time = @_wrapMatchInProperty(regExp, visit.time)
        visit.extendedDate = @_wrapMatchInProperty(regExp, visit.extendedDate)
    visit

  _wrapMatchInProperty: (regExp, property, match) ->
    return unless property
    match = property.match(regExp)
    if match then property.replace(regExp, '<span class="match">' + match + '</span>') else property


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
