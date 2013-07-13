class BH.Models.Day extends Backbone.Model
  @include BH.Modules.I18n
  @include BH.Modules.Url

  initialize: (attrs, options) ->
    @chromeAPI = chrome
    @settings = options.settings
    @set id: @get('date').id()

  toHistory: ->
    date: @get('date')

  toTemplate: ->
    date = @get('date')
    weekId = @startingWeekDate().id()

    properties =
      title: date.format('dddd')
      formalDate: date.format('LLL')
      weekUrl: @urlFor('week', weekId)

    _.extend properties, @toJSON()

  startingWeekDate: ->
    moment(@get('date')).past(@settings.get('startingWeekDay'), 0)
