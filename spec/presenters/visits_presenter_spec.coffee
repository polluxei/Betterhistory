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
      expect(@presenter.visits()).toEqual visits: [
        {
          isGrouped: false,
          host: 'http://www.google.com/',
          path: '1',
          title: 'site',
          url: 'http://www.google.com/1',
          id: 'c191'
        }, {
          isGrouped: false,
          host: 'http://www.google.com/',
          path: '1',
          title: 'site',
          url: 'http://www.google.com/1',
          id: 'c192'
        }
      ]

    describe 'when passed a start and end place', ->
      it 'returns the segment of visits between the start and end numbers', ->
        expect(@presenter.visits(1, 2)).toEqual visits: [
          {
            isGrouped: false,
            host: 'http://www.google.com/'
            path: '1',
            title: 'site',
            url: 'http://www.google.com/1',
            id: 'c194'
          }
        ]
