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
    properties = _.extend @getI18nValues(), @model.toTemplate()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  visitClicked: (ev) ->
    if $(ev.target).hasClass('search_domain')
      ev.preventDefault()
      router.navigate($(ev.target).attr('href'), trigger: true)

  deleteVisitClicked: (ev) ->
    ev.preventDefault()
    element = $(ev.currentTarget).parents('[data-id]').first()
    intervalId = $(ev.currentTarget).parents('.interval').data('id')
    interval = @model.get('history').get(intervalId)
    interval.findVisitById($(element).data('id')).destroy
      success: => element.remove()

  deleteGroupedVisitClicked: (ev) ->
    ev.preventDefault()
    ev.stopPropagation()
    tracker.groupedVisitsDeletion()
    $(ev.currentTarget).siblings('.visits').children().each (i, visit) ->
      $(visit).find('.delete_visit').trigger('click')

    $(ev.currentTarget).parents('.visit').remove()

  deleteIntervalClicked: (ev) ->
    ev.preventDefault()
    tracker.timeIntervalDeletion()
    visitElements = $(ev.currentTarget).parents('.interval').children('.visits').children()
    $(visitElements).each (i, visit) ->
      setTimeout ->
        $(visit).children('.delete').trigger('click')
      , i * 10

      #$(ev.currentTarget).parents('.interval').remove()

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
