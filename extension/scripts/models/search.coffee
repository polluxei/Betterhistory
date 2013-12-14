class BH.Models.Search extends Backbone.Model
  defaults: ->
    query: ''

  validQuery: ->
    @get('query') != ''

  toHistory: ->
    query: @get 'query'
