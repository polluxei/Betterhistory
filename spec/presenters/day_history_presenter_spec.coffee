describe 'BH.Presenters.DayHistoryPresenter', ->
  beforeEach ->
    @date = moment(new Date('October 11, 2012'))
    intervals = [
      {
        id: 'id'
        datetime: 'datetime'
        visits:  [{
          title: 'site'
          url: 'http://google.com'
        }]
      }
    ]

    @presenter = new BH.Presenters.DayHistoryPresenter(intervals)

  describe '#history', ->
    it 'returns the properties for the view template', ->
      expect(@presenter.history()).toEqual [
        {
          amount: '[translated number_of_visits]'
          time: 'translated local_time'
          id: 'id'
          visits: [
            {
              isGrouped: false
              title: 'site'
              url: 'http://google.com'
            }
          ]
        }
      ]
