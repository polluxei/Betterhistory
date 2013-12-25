class BH.Collections.Weeks extends Backbone.Collection
  reload: (startingDay) ->
    @reset()
    for i in _.range(8)
      date = moment(new Date()).past(startingDay, i)
      @add
        id: date.format("M-D-YY")
        date: date
    @trigger 'reloaded'
