class BH.Models.History extends Backbone.Model
  defaults:
    history: []

  isNew: ->
    false

  isEmpty: ->
    @get('history').length == 0

