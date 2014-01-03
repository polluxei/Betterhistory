Fixtures = require '../fixtures/time_grouper_fixtures'

describe 'BH.Workers.TimeGrouper', ->
  beforeEach ->
    @timeGrouper = new BH.Workers.TimeGrouper()

  describe '#run', ->
    describe 'when grouping to 15 minutes', ->
      it 'returns an array of grouped visits grouped into 15 minute intervals', ->
        visits = Fixtures.visitsFor15MinuteInterval()
        results = @timeGrouper.run(visits, interval: 15)

        expect(results[0].datetime).toEqual new Date('11/3/12 12:15')
        expect(results[0].id).toEqual '12:15'
        expect(results[0].visits.length).toEqual 2

        expect(results[1].datetime).toEqual new Date('11/3/12 12:30')
        expect(results[1].id).toEqual '12:30'
        expect(results[1].visits.length).toEqual 1

        expect(results[2].datetime).toEqual new Date('11/3/12 16:00')
        expect(results[2].id).toEqual '16:00'
        expect(results[2].visits.length).toEqual 1

    describe 'when grouping to 30 minutes', ->
      it 'returns an array of grouped visits grouped into 30 minute intervals', ->
        visits = Fixtures.visitsFor30MinuteInterval()
        results = @timeGrouper.run(visits, interval: 30)

        expect(results[0].datetime).toEqual new Date('11/3/12 10:30 AM')
        expect(results[0].id).toEqual '10:30'
        expect(results[0].visits.length).toEqual 1

        expect(results[1].datetime).toEqual new Date('11/3/12 12:00 PM')
        expect(results[1].id).toEqual '12:00'
        expect(results[1].visits.length).toEqual 1

        expect(results[2].datetime).toEqual new Date('11/3/12 1:30 PM')
        expect(results[2].id).toEqual '13:30'
        expect(results[2].visits.length).toEqual 1

        expect(results[3].datetime).toEqual new Date('11/3/12 11:30 PM')
        expect(results[3].id).toEqual '23:30'
        expect(results[3].visits.length).toEqual 1

    describe 'when grouping to 60 minutes', ->
      it 'returns an array of grouped visits grouped into 60 minute intervals', ->
        visits = Fixtures.visitsFor60MinuteInterval()
        results = @timeGrouper.run(visits, interval: 60)

        expect(results[0].datetime).toEqual new Date('11/3/12 11:00')
        expect(results[0].id).toEqual '11:00'
        expect(results[0].visits.length).toEqual 2

        expect(results[1].datetime).toEqual new Date('11/3/12 16:00')
        expect(results[1].id).toEqual '16:00'
        expect(results[1].visits.length).toEqual 2
