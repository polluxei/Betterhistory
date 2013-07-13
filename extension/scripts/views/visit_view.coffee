class BH.Views.VisitView extends Backbone.View
  @include BH.Modules.I18n

  className: 'visit_view'
  template: BH.Templates['visit']

  events:
    'click .delete_visit': 'deleteClicked'

  render: ->
    properties = _.extend(@getI18nValues(), @model.toTemplate())
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  deleteClicked: (ev) ->
    ev.preventDefault()
    @model.destroy
      success: =>
        method = if @_isGroupedAndEmpty() then '_removeGroup' else '_remove'
        @[method]()

  _remove: ->
    @$el.slideUp 'fast', ->
      $el.remove()

  _removeGroup: ->
    $(@_getGroup()).slideUp 'fast', ->
      $el.remove()

  _isGroupedAndEmpty: ->
    if @$el.parents('.expanded').children().length == 1
      true
    else
      false

  _getGroup: ->
    @$el.parents('.grouped_visits_view')

  getI18nValues: ->
    @t [
      'prompt_delete_button'
    ]
