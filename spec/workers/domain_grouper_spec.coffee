Fixtures = require '../fixtures/domain_grouper_fixtures'

describe 'BH.Workers.DomainGrouper', ->
  beforeEach ->
    @domainGrouper = new BH.Workers.DomainGrouper()

  describe '#run', ->
    it 'returns the visit intervals w/ visits grouped by domains', ->
      intervals = Fixtures.visitIntervals()
      results = @domainGrouper.run(intervals)

      expect(results[0].visits[1]).toEqual [
        {url: 'http://google.com/gmail'},
        {url: 'http://google.com/search'}
      ]
      expect(results[2].visits[0]).toEqual [
        {url: 'http://google.com/gmail'},
        {url: 'https://google.com/search'}
      ]
