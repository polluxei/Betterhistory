describe 'BH.Workers.WeekGrouper', ->
  beforeEach ->
    @weekGrouper = new BH.Workers.WeekGrouper
      startingWeekDay: 'Monday'

  describe '#run', ->
    beforeEach ->
      @visit1 =
        lastVisitTime: new Date('12/2/13 4:00 PM').getTime()
      @visit2 =
        lastVisitTime: new Date('12/5/13 3:00 AM').getTime()
      @visit3 =
        lastVisitTime: new Date('12/10/13 6:00 AM').getTime()
      @visit4 =
        lastVisitTime: new Date('12/10/13 2:00 AM').getTime()
      @visit5 =
        lastVisitTime: new Date('12/15/13 4:00 PM').getTime()
      @visit6 =
        lastVisitTime: new Date('12/16/13 3:00 AM').getTime()
      @visit7 =
        lastVisitTime: new Date('12/31/13 11:00 PM').getTime()
      @visit8 =
        lastVisitTime: new Date('12/30/13 4:00 PM').getTime()

      @visits = [
        @visit1, @visit2, @visit3, @visit4
        @visit5, @visit6, @visit7, @visit8
      ]

    it 'returns an object of weeks, starting on monday, containing visits', ->
      @weekGrouper.setStartingWeekDay('monday')
      expect(@weekGrouper.run(@visits)).toEqual [
        {
          date: new Date('12/30/2013')
          visits: [@visit7, @visit8]
        }, {
          date: new Date('12/23/2013')
          visits: []
        }, {
          date: new Date('12/16/2013')
          visits: [@visit6]
        }, {
          date: new Date('12/9/2013')
          visits: [@visit3, @visit4, @visit5]
        }, {
          date: new Date('12/2/2013')
          visits: [@visit1, @visit2]
        }
      ]

    it 'returns an object of weeks, starting on friday, containing visits', ->
      @weekGrouper.setStartingWeekDay('friday')
      expect(@weekGrouper.run(@visits)).toEqual [
        {
          date: new Date('12/27/2013')
          visits: [@visit7, @visit8]
        }, {
          date: new Date('12/20/2013')
          visits: []
        }, {
          date: new Date('12/13/2013')
          visits: [@visit5, @visit6]
        }, {
          date: new Date('12/6/2013')
          visits: [@visit3, @visit4]
        }, {
          date: new Date('11/29/2013')
          visits: [@visit1, @visit2]
        }
      ]
