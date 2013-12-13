describe 'BH.Presenters.DayHistoryPresenter', ->
  beforeEach ->
    global.settings = new BH.Models.Settings()
    @date = moment(new Date('October 11, 2012'))
    model = new BH.Models.DayHistory
      history: new BH.Collections.Intervals [
        {
          id: 'id'
          datetime: 'datetime'
          visits: new BH.Collections.Visits [
            new BH.Models.Visit
              title: 'site'
              url: 'http://google.com'
          ]
        }
      ]

    @presenter = new BH.Presenters.DayHistoryPresenter(model)

  describe '#history', ->
    it 'returns the properties for the view template', ->
      expect(@presenter.history()).toEqual history: [
        {
          amount: '[translated number_of_visits]'
          time: 'translated local_time'
          id: 'id'
          visits: [
            {
              isGrouped: false
              host: null
              path: undefined
              title: 'site'
              url: 'http://google.com'
              id: 'c167'
            }
          ]
        }
      ]
