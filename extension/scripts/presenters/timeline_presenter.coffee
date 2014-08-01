class BH.Presenters.Timeline extends BH.Presenters.Base
  constructor: (@json) ->

  timeline: (startDate) ->
    dates = for i in [0..6]
      date = moment(startDate).startOf('day').subtract 'days', i
      label: getLabel(date)
      date: date.format('MMM Do')
      selected: true if date.isSame(moment(@json.date).startOf('day'))
      id: date.format('M-D-YY')

    dates: dates
    nextButtonDisabled: dates[0].id == moment().format('M-D-YY')

getLabel = (date) ->
  return 'Today' if moment().startOf('day').isSame(date)
  return 'Yesterday' if moment().subtract('days', 1).startOf('day').isSame(date)
  date.format('dddd')
