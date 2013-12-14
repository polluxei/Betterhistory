class BH.Models.Week extends Backbone.Model
  initialize: (attrs, options) ->
    @set id: @get('date').id()

  toHistory: ->
    startDate: @get 'date'
    endDate: moment(@get 'date').add('days', 6)
