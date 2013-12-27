describe 'BH.Presenters.WeekHistoryPresenter', ->
  beforeEach ->
    days = [
      {
        name: 'Monday'
        visits: [1]
      }, {
        name: 'Tuesday'
        visits: [1, 2, 3]
      }, {
        name: 'Wednesday'
        visits: [1, 2, 3, 4]
      }, {
        name: 'Thursday'
        visits: [1]
      }, {
        name: 'Friday'
        visits: [1, 2]
      }, {
        name: 'Saturday'
        visits: []
      }, {
        name: 'Sunday'
        visits: [1]
      }
    ]
    @presenter = new BH.Presenters.WeekHistoryPresenter(days)

  describe '#history', ->
    it 'returns the properties for the view template', ->
      expect(@presenter.history()).toEqual
        total: 12
        days: [
          {
            count: 1
            day: 'Monday'
            percentage: '25%'
          }, {
            count: 3
            day: 'Tuesday'
            percentage: '75%'
          }, {
            count: 4
            day: 'Wednesday'
            percentage: '100%'
          }, {
            count: 1
            day: 'Thursday'
            percentage: '25%'
          }, {
            count: 2
            day: 'Friday'
            percentage: '50%'
          }, {
            count: 0
            day: 'Saturday'
            percentage: '0%'
          }, {
            count: 1
            day: 'Sunday'
            percentage: '25%'
          }
        ]
