class BH.Collections.Visits extends Backbone.Collection
  destroyAll: (options) ->
    while(@length > 0)
      @at(0).destroy() if @at(0)
    options.success() if options?

  toTemplate: (start, end)->
    visits = []

    if start? && end?
      for i in [start...end]
        visits.push(@models[i].toTemplate()) if @models[i]?
    else
      for model in @models
        visits.push model.toTemplate()

    visits: visits
