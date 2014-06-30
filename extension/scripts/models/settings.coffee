class BH.Models.Settings extends Backbone.Model
  storeName: 'settings'

  defaults: ->
    searchByDomain: true
    searchBySelection: true
    openLocation: 'last_visit'
