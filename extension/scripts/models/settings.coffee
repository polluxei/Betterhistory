class BH.Models.Settings extends Backbone.Model
  @include BH.Modules.I18n

  storeName: 'settings'

  defaults: ->
    timeGrouping: 15
    domainGrouping: true
    searchByDomain: true
    searchBySelection: true
    openLocation: 'last_visit'
    startingWeekDay: 'Monday'
    weekDayOrder: 'ascending'

  initialize: ->
    @chromeAPI = chrome

  toTemplate: ->
    properties =
      startingWeekDays: []
      openLocations: []
      timeGroupings: []
      weekDayOrders: []
      searchBySelection: @get 'searchBySelection'
      searchByDomain: @get 'searchByDomain'
      domainGrouping: @get 'domainGrouping'

    _(['monday', 'tuesday', 'wednesday',
      'thursday', 'friday', 'saturday', 'sunday']).each (day) =>
      properties.startingWeekDays.push
        text: @t day
        value: day

    _(['last_visit', 'current_day', 'current_week']).each (location) =>
      properties.openLocations.push
        text: @t location
        value: location

    _(['descending', 'ascending']).each (order) =>
      properties.weekDayOrders.push
        text: @t order
        value: order

    _([15, 30, 60]).each (timeGrouping) =>
      properties.timeGroupings.push
        text: @t "#{timeGrouping}_minutes_option"
        value: timeGrouping

    properties

  parse: (data) ->
    attributes = try
      JSON.parse(data)
    attributes = {} unless attributes?

    attributes.timeGrouping = if attributes.timeGrouping?
      parseInt attributes.timeGrouping, 10
    else
      @defaults.timeGrouping

    attributes
