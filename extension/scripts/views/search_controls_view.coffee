class BH.Views.SearchControlsView extends Backbone.View
  @include BH.Modules.I18n

  className: 'search_controls_view'
  template: BH.Templates['search_controls']

  events:
    'click .delete_all': 'clickedDeleteAll'

  initialize: ->
    @collection.on 'reset', @onHistoryChanged, @
    @page = new Backbone.Model(page: 1)

  render: ->
    properties = _.extend @getI18nValues(), @model.toJSON()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  onHistoryChanged: ->
    deleteButton = @$('.delete_all')
    if @collection.length == 0 || !@model.get('query')?
      deleteButton.attr('disabled', 'disabled')
    else
      deleteButton.removeAttr('disabled')

    searchPaginationView = new BH.Views.SearchPaginationView
      collection: @collection
      query: @model.get('query')
      el: $('.pagination')
      model: @page
    searchPaginationView.render()


  clickedDeleteAll: (ev) ->
    ev.preventDefault()
    if $(ev.target).parent().attr('disabled') != 'disabled'
      @promptView = BH.Views.CreatePrompt(@t('confirm_delete_all_search_results'))
      @promptView.open()
      @promptView.model.on('change', @deleteAction, @)

  deleteAction: (prompt) ->
    if prompt.get('action')
      analyticsTracker.searchResultsDeletion()

      new Historian.Search(@model.get('query')).destroy {}, =>
        @collection.reset []
        @model.unset 'cacheDatetime'
        @promptView.close()
    else
      @promptView.close()

  getI18nValues: ->
    @t [
      'delete_all_visits_for_search_button',
    ]
