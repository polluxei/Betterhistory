describe 'BH.Presenters.WeekPresenter', ->
  beforeEach ->
    @date = moment(new Date('October 8, 2012'))
    week = id: '10-8-12', date: @date
    @presenter = new BH.Presenters.WeekPresenter(week)

  describe '#inflatedWeek', ->
    it 'returns the properties needed for a view template', ->
      expect(@presenter.inflatedWeek()).toEqual
        days: [
          {
            day: 'Monday'
            title: '[translated monday]'
            inFuture: false
            url: '#days/10-8-12'
          }, {
            day: 'Tuesday'
            title: '[translated tuesday]'
            inFuture: false
            url: '#days/10-9-12'
          }, {
            day: 'Wednesday'
            title: '[translated wednesday]'
            inFuture: false
            url: '#days/10-10-12'
          }, {
            day: 'Thursday'
            title: '[translated thursday]'
            inFuture: false
            url: '#days/10-11-12'
          }, {
            day: 'Friday'
            title: '[translated friday]'
            inFuture: false
            url: '#days/10-12-12'
          }, {
            day: 'Saturday'
            title: '[translated saturday]'
            inFuture: false
            url: '#days/10-13-12'
          }, {
            day: 'Sunday'
            title: '[translated sunday]'
            inFuture: false
            url: '#days/10-14-12'
          }
        ]
        shortTitle: 'translated short_date'
        title: '[translated date_week_label]'
        id: '10-8-12'
        url: '#weeks/10-8-12'
        date: @date
        filter: '{"week":"10-8-12"}'
