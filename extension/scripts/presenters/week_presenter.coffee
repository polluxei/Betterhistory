class BH.Presenters.WeekPresenter extends BH.Presenters.Base
  constructor: (@week) ->

  inflatedWeek: ->
    copy =
      shortTitle: moment(@week.date).format('L')
      url: "#weeks/#{@week.id}"
      title: @t('date_week_label', [
        moment(@week.date).format('LL')
      ])

    days = for day in inflateDays(@week.date)
      out =
        day: moment(day.id()).lang('en').format('dddd')
        title: day.format('dddd')
        inFuture: moment() < day
        url: "#days/#{day.id()}"

    _.extend copy, @week, days: days

inflateDays = (date) ->
  days = for i in [0..6]
    moment(new Date(date)).add('days', i)

  if settings.get('weekDayOrder') == 'descending'
    days.reverse()

  days
