describe 'BH.Presenters.WeekHistoryPresenter', ->
  beforeEach ->
    @startDate = moment(new Date('October 11, 2012'))
    @endDate = moment(new Date('October 17, 2012'))
    model = new BH.Models.WeekHistory
      startDate: @startDate
      endDate: @endDate
      history:
        Monday: [1]
        Tuesday: [1, 2, 3]
        Wednesday: [1, 2, 3, 4]
        Thursday: [1]
        Friday: [1, 2]
        Saturday: []
        Sunday: [1]
    @presenter = new BH.Presenters.WeekHistoryPresenter(model)

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
