describe 'BH.Presenters.CalendarPresenter', ->
  beforeEach ->
    @presenter = new BH.Presenters.CalendarPresenter
      month: 'March'
      year: '2014'

  describe '#calendar', ->
    it 'returns all the days in a month with appropiate padding starting on monday', ->
      expect(@presenter.calendar('Monday')).toEqual [
        {
          days: [
            { weekId: '2-23-14', day: 'sunday' },
            { weekId: '2-24-14', day: 'monday' },
            { weekId: '2-25-14', day: 'tuesday' },
            { weekId: '2-26-14', day: 'wednesday' },
            { weekId: '2-27-14', day: 'thursday' },
            { weekId: '2-28-14', day: 'friday' },
            { number: 1, day: 'saturday', weekId: '3-1-14', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '3-2-14', number: 2, day: 'sunday', inMonth: true },
            { number: 3, day: 'monday', weekId: '3-3-14', inMonth: true },
            { number: 4, day: 'tuesday', weekId: '3-4-14', inMonth: true },
            { number: 5, day: 'wednesday', weekId: '3-5-14', inMonth: true },
            { number: 6, day: 'thursday', weekId: '3-6-14', inMonth: true },
            { number: 7, day: 'friday', weekId: '3-7-14', inMonth: true },
            { number: 8, day: 'saturday', weekId: '3-8-14', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '3-9-14', number: 9, day: 'sunday', inMonth: true },
            { number: 10, day: 'monday', weekId: '3-10-14', inMonth: true },
            { number: 11, day: 'tuesday', weekId: '3-11-14', inMonth: true },
            { number: 12, day: 'wednesday', weekId: '3-12-14', inMonth: true },
            { number: 13, day: 'thursday', weekId: '3-13-14', inMonth: true },
            { number: 14, day: 'friday', weekId: '3-14-14', inMonth: true },
            { number: 15, day: 'saturday', weekId: '3-15-14', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '3-16-14', number: 16, day: 'sunday', inMonth: true },
            { number: 17, day: 'monday', weekId: '3-17-14', inMonth: true },
            { number: 18, day: 'tuesday', weekId: '3-18-14', inMonth: true },
            { number: 19, day: 'wednesday', weekId: '3-19-14', inMonth: true },
            { number: 20, day: 'thursday', weekId: '3-20-14', inMonth: true },
            { number: 21, day: 'friday', weekId: '3-21-14', inMonth: true },
            { number: 22, day: 'saturday', weekId: '3-22-14', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '3-23-14', number: 23, day: 'sunday', inMonth: true },
            { number: 24, day: 'monday', weekId: '3-24-14', inMonth: true },
            { number: 25, day: 'tuesday', weekId: '3-25-14', inMonth: true },
            { number: 26, day: 'wednesday', weekId: '3-26-14', inMonth: true },
            { number: 27, day: 'thursday', weekId: '3-27-14', inMonth: true },
            { number: 28, day: 'friday', weekId: '3-28-14', inMonth: true },
            { number: 29, day: 'saturday', weekId: '3-29-14', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '3-30-14', number: 30, day: 'sunday', inMonth: true },
            { number: 31, day: 'monday', weekId: '3-31-14', inMonth: true },
            { weekId: '4-2-14', day: 'wednesday' },
            { weekId: '4-3-14', day: 'thursday' },
            { weekId: '4-4-14', day: 'friday' },
            { weekId: '4-5-14', day: 'saturday' },
            { weekId: '4-6-14', day: 'sunday' }
          ]
        }
      ]

    it 'returns all the days in a month with appropiate padding starting on thursday', ->
      @presenter.json = month:'December', year: '2011'
      expect(@presenter.calendar('Thursday')).toEqual [
        {
          days: [
            { weekId: '11-27-11', day: 'sunday' },
            { weekId: '11-28-11', day: 'monday' },
            { weekId: '11-29-11', day: 'tuesday' },
            { weekId: '11-30-11', day: 'wednesday' },
            { number: 1, day: 'thursday', weekId: '12-1-11', inMonth: true },
            { number: 2, day: 'friday', weekId: '12-2-11', inMonth: true },
            { number: 3, day: 'saturday', weekId: '12-3-11', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '12-4-11', number: 4, day: 'sunday', inMonth: true },
            { number: 5, day: 'monday', weekId: '12-5-11', inMonth: true },
            { number: 6, day: 'tuesday', weekId: '12-6-11', inMonth: true },
            { number: 7, day: 'wednesday', weekId: '12-7-11', inMonth: true },
            { number: 8, day: 'thursday', weekId: '12-8-11', inMonth: true },
            { number: 9, day: 'friday', weekId: '12-9-11', inMonth: true },
            { number: 10, day: 'saturday', weekId: '12-10-11', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '12-11-11', number: 11, day: 'sunday', inMonth: true },
            { number: 12, day: 'monday', weekId: '12-12-11', inMonth: true },
            { number: 13, day: 'tuesday', weekId: '12-13-11', inMonth: true },
            { number: 14, day: 'wednesday', weekId: '12-14-11', inMonth: true },
            { number: 15, day: 'thursday', weekId: '12-15-11', inMonth: true },
            { number: 16, day: 'friday', weekId: '12-16-11', inMonth: true },
            { number: 17, day: 'saturday', weekId: '12-17-11', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '12-18-11', number: 18, day: 'sunday', inMonth: true },
            { number: 19, day: 'monday', weekId: '12-19-11', inMonth: true },
            { number: 20, day: 'tuesday', weekId: '12-20-11', inMonth: true },
            { number: 21, day: 'wednesday', weekId: '12-21-11', inMonth: true },
            { number: 22, day: 'thursday', weekId: '12-22-11', inMonth: true },
            { number: 23, day: 'friday', weekId: '12-23-11', inMonth: true },
            { number: 24, day: 'saturday', weekId: '12-24-11', inMonth: true }
          ]
        }, {
          days: [
            { weekId: '12-25-11', number: 25, day: 'sunday', inMonth: true },
            { number: 26, day: 'monday', weekId: '12-26-11', inMonth: true },
            { number: 27, day: 'tuesday', weekId: '12-27-11', inMonth: true },
            { number: 28, day: 'wednesday', weekId: '12-28-11', inMonth: true },
            { number: 29, day: 'thursday', weekId: '12-29-11', inMonth: true },
            { number: 30, day: 'friday', weekId: '12-30-11', inMonth: true },
            { number: 31, day: 'saturday', weekId: '12-31-11', inMonth: true }
          ]
        }
      ]
