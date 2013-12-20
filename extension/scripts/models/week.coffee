class BH.Models.Week extends Backbone.Model
  initialize: ->
    @set id: moment(@get('date')).id()
