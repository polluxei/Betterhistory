class BH.Models.Week extends Backbone.Model
  @include BH.Modules.I18n
  @include BH.Modules.Url

  initialize: (attrs, options) ->
    @chromeAPI = chrome
    @settings = options.settings
    @set id: @get('date').id()

  toHistory: ->
    startDate: @get 'date'
    endDate: moment(@get 'date').add('days', 6)

  toTemplate: ->
    days = for day in @inflateDays()
      day: moment(day.id()).lang('en').format('dddd')
      title: day.format('dddd')
      inFuture: moment() < day
      url: @urlFor('day', day.id())

    copy =
      shortTitle: @get('date').format('L')
      url: @urlFor('week', @id)
      title: @t('date_week_label', [
        @get('date').format('LL')
      ])

    _.extend copy, @toJSON(), days: days

  inflateDays: ->
    days = for i in [0..6]
      moment(@get('date')).add('days', i)

    if @settings.get('weekDayOrder') == 'descending'
      days.reverse()

    days
