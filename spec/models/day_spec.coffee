describe 'BH.Models.Day', ->
  beforeEach ->
    @date = moment(new Date('October 11, 2012'))

    @day = new BH.Models.Day date: @date

  describe '#initialize', ->
    it 'sets the id', ->
      expect(@day.id).toEqual('10-11-12')

  describe '#toHistory', ->
    it 'returns the needed properties for the history API', ->
      expect(@day.toHistory()).toEqual
        date: @date
