class BH.Models.Settings extends Backbone.Model
  storeName: 'settings'

  defaults: ->
    timeGrouping: 15
    domainGrouping: true
    searchByDomain: true
    searchBySelection: true
    openLocation: 'last_visit'
    startingWeekDay: 'Monday'
    weekDayOrder: 'ascending'
