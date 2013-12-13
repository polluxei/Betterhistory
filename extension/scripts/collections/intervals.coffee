class BH.Collections.Intervals extends Backbone.Collection
  model: BH.Models.Interval

  destroyAll: ->
    while(@length > 0)
      @at(0).destroy() if @at(0)
