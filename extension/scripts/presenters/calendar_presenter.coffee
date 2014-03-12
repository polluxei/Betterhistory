class BH.Presenters.CalendarPresenter extends BH.Presenters.Base
  constructor: (@json) ->

  calendar: ->
    stillInMonth = true
    dateMonth = new Date("#{@json.month} #{@json.year}")
    weeks = [{
      id: ''
      days: [{}]
    }]
    date = new Date(dateMonth)

    # Pad the beginning
    if date.getDay() != 0
      for day in _.range(0, date.getDay() - 1)
        _.first(weeks).days.push {}

    # Fill in the middle
    while stillInMonth
      if date.getMonth() != dateMonth.getMonth()
        stillInMonth = false
      else
        if date.getDay() == 0
          weekId = moment(date).format("M-D-YY")
          weeks.push
            id: weekId
            days:[{
              number: date.getDate()
              inMonth: true
            }]
        else
          _.last(weeks).days.push
            number: date.getDate()
            inMonth: true

        date.setDate(date.getDate() + 1)

    # Pad the ending
    while _.last(weeks).days.length != 7
      _.last(weeks).days.push {}

    weeks
