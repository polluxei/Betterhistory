describe 'BH.Presenters.DayPresenter', ->
  beforeEach ->
    global.settings = new BH.Models.Settings
      startingWeekDay: 'monday'
    @date = moment(new Date('October 11, 2012'))
    model = new BH.Models.Day(date: @date)
    @presenter = new BH.Presenters.DayPresenter(model)

  describe '#day', ->
    it 'returns the properties needed for a view template', ->
      expect(@presenter.day()).toEqual
        title: '[translated thursday]'
        formalDate: 'translated formal_date'
        weekUrl: '#weeks/10-8-12'
        id: '10-11-12'
        date: @date
