describe 'BH.Presenters.SearchHistoryPresenter', ->
  beforeEach ->
    model = new BH.Models.Search
      query: 'search term'
      history: new BH.Collections.Visits [
        new BH.Models.Visit(
          title: 'site 1'
          url: 'http://www.google.com/1'
        ),
        new BH.Models.Visit(
          title: 'site 2'
          url: 'http://www.google.com/2'
        ),
        new BH.Models.Visit(
          title: 'site 3'
          url: 'http://www.google.com/3'
        )
      ]
    @presenter =  new BH.Presenters.SearchHistoryPresenter(model)

  describe '#history', ->
    it 'returns the properties for the view template', ->
      results = @presenter.history()
      results.visits = for visit in results.visits
        delete visit.id
        visit

      expect(results).toEqual visits: [
        {
          isGrouped: false
          host: 'http://www.google.com/'
          path: '1'
          title: 'site 1'
          url: 'http://www.google.com/1'
        }, {
          isGrouped: false
          host: 'http://www.google.com/'
          path: '2'
          title: 'site 2'
          url: 'http://www.google.com/2'
        }, {
          isGrouped: false
          host: 'http://www.google.com/'
          path: '3'
          title: 'site 3'
          url: 'http://www.google.com/3'
        }
      ]

    describe 'when a segment of history is requested', ->
      it 'called the history model with a start and end range', ->
        results = @presenter.history(1, 2)
        results.visits = for visit in results.visits
          delete visit.id
          visit

        expect(results).toEqual visits: [
          {
            isGrouped: false,
            host: 'http://www.google.com/',
            path: '2',
            title: 'site 2',
            url: 'http://www.google.com/2',
          }
        ]
