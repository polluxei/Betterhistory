class BH.Models.State extends Backbone.Model
  @include BH.Modules.I18n
  @include BH.Modules.Url

  storeName: 'state'

  initialize: (attrs, options) ->
    @chromeAPI = chrome
    @settings = options.settings

    weekId = @startingWeekDate().id()
    @set route: @urlFor('week', weekId)

  updateRoute: ->
    if @settings.get('openLocation') == 'current_day'
      route = @urlFor 'day', moment(new Date()).id()

    else if @settings.get('openLocation') == 'current_week'
      weekId = @startingWeekDate().id()
      route = @urlFor 'week', weekId

    @set route: route if route?
    @save()

  startingWeekDate: ->
    moment(new Date()).past(@settings.get('startingWeekDay'), 0)

  parse: (data) ->
    JSON.parse data
