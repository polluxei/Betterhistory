class BH.Presenters.WeekPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  week: ->
    copy =
      shortTitle: moment(@model.get('date')).format('L')
      url: "#weeks/#{@model.id}"
      title: @t('date_week_label', [
        moment(@model.get('date')).format('LL')
      ])

    days = for day in inflateDays(@model.get('date'))
      out =
        day: moment(day.id()).lang('en').format('dddd')
        title: day.format('dddd')
        inFuture: moment() < day
        url: "#days/#{day.id()}"

    _.extend copy, @model.toJSON(), days: days

inflateDays = (date) ->
  days = for i in [0..6]
    moment(new Date(date)).add('days', i)

  if settings.get('weekDayOrder') == 'descending'
    days.reverse()

  days
