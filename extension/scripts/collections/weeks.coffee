class BH.Collections.Weeks extends Backbone.Collection
  @include BH.Modules.I18n

  model: BH.Models.Week

  initialize: (attrs, options) ->
    @chromeAPI = chrome
    @settings = options.settings

  toTemplate: ->
    weeks = for model in @models
      model.toTemplate()

    weeks: weeks

  reload: (startingDay) ->
    @reset()
    for i in _.range(10)
      @add(
        {date: moment(new Date()).past(startingDay, i)},
        {settings: @settings}
      )
    @trigger 'reloaded'
