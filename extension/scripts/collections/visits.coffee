class BH.Collections.Visits extends Backbone.Collection
  destroyAll: (options) ->
    while(@length > 0)
      @at(0).destroy() if @at(0)
    options.success() if options?
