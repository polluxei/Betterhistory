class BH.Models.Interval extends Backbone.Model
  @include BH.Modules.I18n

  initialize: (attrs, options) ->
    @chromeAPI = chrome
    @settings = options.settings

  toTemplate: ->
    _.extend
      amount: @t('number_of_visits', [
        @get('visits').length.toString(),
        '<span class="amount">',
        '</span>'
      ])
      time: moment(@get('datetime')).format('LT')
      id: @id

    , @get('visits').toTemplate()

  findVisitById: (id) ->
    foundVisit = @get('visits').get(id)
    return foundVisit if foundVisit?

    @get('visits').find (visit) =>
      if visit.get('visits')?
        foundVisit = visit.get('visits').get(id)
        return true if foundVisit?
    return foundVisit
