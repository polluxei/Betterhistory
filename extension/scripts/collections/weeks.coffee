class BH.Collections.Weeks extends Backbone.Collection
  model: BH.Models.Week

  initialize: (attrs, options) ->
    @chromeAPI = chrome

  reload: (startingDay) ->
    @reset()
    for i in _.range(8)
      @add date: moment(new Date()).past(startingDay, i)
    @trigger 'reloaded'
