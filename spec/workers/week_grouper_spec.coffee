Fixtures = require '../fixtures/week_grouper_fixtures'

describe 'BH.Workers.WeekGrouper', ->
  beforeEach ->
    @weekGrouper = new BH.Workers.WeekGrouper
      startingWeekDay: 'Monday'

  describe '#run', ->
    it 'returns an object of weeks, starting on monday, containing visits', ->
      @weekGrouper.setStartingWeekDay('monday')

      visits = Fixtures.variousVisits()
      results = @weekGrouper.run(visits)

      expect(results[0].date).toEqual new Date('12/30/2013')
      expect(results[0].visits.length).toEqual 2

      expect(results[1].date).toEqual new Date('12/23/2013')
      expect(results[1].visits.length).toEqual 0

      expect(results[2].date).toEqual new Date('12/16/2013')
      expect(results[2].visits.length).toEqual 1

      expect(results[3].date).toEqual new Date('12/9/2013')
      expect(results[3].visits.length).toEqual 3

      expect(results[4].date).toEqual new Date('12/2/2013')
      expect(results[4].visits.length).toEqual 2

    it 'returns an object of weeks, starting on friday, containing visits', ->
      @weekGrouper.setStartingWeekDay('friday')

      visits = Fixtures.variousVisits()
      results = @weekGrouper.run(visits)

      expect(results[0].date).toEqual new Date('12/27/2013')
      expect(results[0].visits.length).toEqual 2

      expect(results[1].date).toEqual new Date('12/20/2013')
      expect(results[1].visits.length).toEqual 0

      expect(results[2].date).toEqual new Date('12/13/2013')
      expect(results[2].visits.length).toEqual 2

      expect(results[3].date).toEqual new Date('12/6/2013')
      expect(results[3].visits.length).toEqual 2

      expect(results[4].date).toEqual new Date('11/29/2013')
      expect(results[4].visits.length).toEqual 2
