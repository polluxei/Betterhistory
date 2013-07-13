class BH.Collections.Intervals extends Backbone.Collection
  model: BH.Models.Interval

  toTemplate: ->
    intervals = for model in @models
      model.toTemplate()

    intervals: intervals

  destroyAll: ->
    while(@length > 0)
      @at(0).destroy() if @at(0)
