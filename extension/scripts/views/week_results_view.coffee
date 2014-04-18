class BH.Views.WeekResultsView extends Backbone.Vieew
  initialize: ->
    @collection.bind('reset', @render, @)

