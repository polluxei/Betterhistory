class BH.Presenters.SettingsPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  settings: ->
    properties =
      startingWeekDays: []
      openLocations: []
      timeGroupings: []
      weekDayOrders: []
      searchBySelection: @model.get 'searchBySelection'
      searchByDomain: @model.get 'searchByDomain'
      domainGrouping: @model.get 'domainGrouping'

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
