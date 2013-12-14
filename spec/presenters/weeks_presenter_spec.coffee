describe 'BH.Presenters.WeeksPresenter', ->
  beforeEach ->
    collection = new BH.Collections.Weeks [
      {date: moment('Oct 12, 2010')},
      {date: moment('Oct 19, 2010')}
    ]
    @presenter = new BH.Presenters.WeeksPresenter(collection)

  describe '#weeks', ->
    it 'returns the properties needed for a view template', ->
      expect(@presenter.weeks()).toEqual
        weeks: [
          {
            id: '10-12-10'
            url: '#weeks/10-12-10'
            shortTitle: 'translated short_date'
          }, {
            id: '10-19-10'
            url: '#weeks/10-19-10'
            shortTitle: 'translated short_date'
          }
        ]
