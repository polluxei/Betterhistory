class BH.Collections.GroupedVisits extends Backbone.Collection
  model: BH.Models.Visit

  toTemplate: ->
    for model in @models
      model.toTemplate()
