Fixtures = require '../fixtures/day_grouper_fixtures'

describe 'BH.Workers.DayGrouper', ->
  beforeEach ->
    @dayGrouper = new BH.Workers.DayGrouper()

  describe '#run', ->
    it 'returns an week object of visits grouped by day', ->
      visits = Fixtures.variousVisits()
      results = @dayGrouper.run(visits)

      expect(results[0].name).toEqual 'Sunday'
      expect(results[0].visits.length).toEqual 1

      expect(results[1].name).toEqual 'Monday'
      expect(results[1].visits.length).toEqual 1

      expect(results[2].name).toEqual 'Tuesday'
      expect(results[2].visits.length).toEqual 0

      expect(results[3].name).toEqual 'Wednesday'
      expect(results[3].visits.length).toEqual 2

      expect(results[4].name).toEqual 'Thursday'
      expect(results[4].visits.length).toEqual 0

      expect(results[5].name).toEqual 'Friday'
      expect(results[5].visits.length).toEqual 1

      expect(results[6].name).toEqual 'Saturday'
      expect(results[6].visits.length).toEqual 3
