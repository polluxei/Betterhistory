describe 'BH.Presenters.DayPresenter', ->
  beforeEach ->
    global.settings = new BH.Models.Settings
      startingWeekDay: 'monday'
    @date = moment(new Date('October 11, 2012'))
    day = date: @date, id: '10-11-12'
    @presenter = new BH.Presenters.DayPresenter(day)

  describe '#dayInfo', ->
    it 'returns the properties needed for a view template', ->
      expect(@presenter.dayInfo()).toEqual
        title: '[translated thursday]'
        formalDate: 'translated formal_date'
        weekUrl: '#weeks/10-8-12'
        id: '10-11-12'
        date: @date
        filter : '{"day":"10-11-12"}'
