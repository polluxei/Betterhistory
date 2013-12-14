class BH.Models.Day extends Backbone.Model
  initialize: ->
    @set id: @get('date').id()

  toHistory: ->
    date: @get('date')
