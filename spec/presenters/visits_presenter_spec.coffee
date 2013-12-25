describe 'BH.Presenters.VisitsPresenter', ->
  beforeEach ->
    collection = new BH.Collections.Visits()
    collection.add [
      new BH.Models.Visit(
        title: 'site'
        url: 'http://www.google.com/1'
      ),
      new BH.Models.Visit(
        title: 'site'
        url: 'http://www.google.com/1'
      )
    ]

    @presenter = new BH.Presenters.VisitsPresenter(collection)

  describe '#visits', ->
    it 'returns the templated models', ->
      results = @presenter.visits()
      results.visits = for visit in results.visits
        delete visit.id
        visit
      expect(results).toEqual visits: [
        {
          isGrouped: false,
          host: 'http://www.google.com/',
          path: '1',
          title: 'site',
          url: 'http://www.google.com/1'
        }, {
          isGrouped: false,
          host: 'http://www.google.com/',
          path: '1',
          title: 'site',
          url: 'http://www.google.com/1'
        }
      ]

    describe 'when passed a start and end place', ->
      it 'returns the segment of visits between the start and end numbers', ->
        results = @presenter.visits(1, 2)
        results.visits = for visit in results.visits
          delete visit.id
          visit
        expect(results).toEqual visits: [
          {
            isGrouped: false,
            host: 'http://www.google.com/'
            path: '1',
            title: 'site',
            url: 'http://www.google.com/1'
          }
        ]
