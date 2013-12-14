describe 'BH.Models.Week', ->
  beforeEach ->
    @date = moment(new Date('October 8, 2012'))
    @week = new BH.Models.Week date: @date,
      settings: new BH.Models.Settings()

  describe '#initialize', ->
    it 'sets the id', ->
      expect(@week.id).toEqual('10-8-12')

  describe '#toHistory', ->
    it 'returns the needed properties for the history API', ->
      expect(@week.toHistory()).toEqual
        startDate: @date
        endDate: moment(new Date('October 14, 2012'))
