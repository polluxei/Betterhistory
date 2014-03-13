class BH.Presenters.CalendarPresenter extends BH.Presenters.Base
  constructor: (@json) ->

  calendar: ->
    days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
    stillInMonth = true
    dateMonth = new Date("#{@json.month} #{@json.year}")
    weeks = []
    date = new Date(dateMonth)

    # Pad the beginning
    if date.getDay() != 0
      weeks.push days: []
      for day in _.range(1, date.getDay() + 1)
        pastDate = new Date(date)
        pastDate.setDate(pastDate.getDate() - day)
        _.first(weeks).days.unshift
          weekId: moment(pastDate).format('M-D-YY')
          day: days[pastDate.getDay()]

    # Fill in the middle
    while stillInMonth
      if date.getMonth() != dateMonth.getMonth()
        stillInMonth = false
      else
        if date.getDay() == 0
          weeks.push
            days:[{
              weekId: moment(date).format('M-D-YY')
              number: date.getDate()
              day: days[date.getDay()]
              inMonth: true
              today: isToday(date)
            }]
        else
          _.last(weeks).days.push
            number: date.getDate()
            day: days[date.getDay()]
            weekId: moment(date).format('M-D-YY')
            inMonth: true
            today: isToday(date)

        date.setDate(date.getDate() + 1)

    # Pad the ending
    index = 1
    while _.last(weeks).days.length != 7
      futureDate = new Date(date)
      futureDate.setDate(futureDate.getDate() + index)
      _.last(weeks).days.push
        weekId: moment(futureDate).format('M-D-YY')
        day: days[futureDate.getDay()]
      index += 1

    weeks

isToday = (date) ->
  today = new Date()
  today.setHours(0,0,0,0)
  today.getTime() == date.getTime()
