describe 'BH.Models.DayHistory', ->
  beforeEach ->
    @date = moment(new Date('October 11, 2012'))
    @dayHistory = new BH.Models.DayHistory {date: @date},
      settings: new BH.Models.Settings()

  describe '#toChrome', ->
    it 'returns the reading properties when reading is true', ->
      expect(@dayHistory.toChrome()).toEqual
        startTime: new Date(@date.sod()).getTime()
        endTime: new Date(@date.eod()).getTime()
        text: ''

    it 'returns the deleting properties when reading is false', ->
      expect(@dayHistory.toChrome(false)).toEqual
        startTime: new Date(@date.sod()).getTime()
        endTime: new Date(@date.eod()).getTime()

  describe 'deleting history', ->
    beforeEach ->
      @deleteRange = @dayHistory.chromeAPI.history.deleteRange
      @deleteRange.andCallFake (options, callback) ->
        callback()

    it 'calls to the history delete method with params and callback', ->
      @dayHistory.destroy()
      expect(@deleteRange).toHaveBeenCalledWith
        startTime: new Date(@date.sod()).getTime()
        endTime: new Date(@date.eod()).getTime()
      , jasmine.any(Function)

    it 'resets the history', ->
      @dayHistory.destroy()
      expect(@dayHistory.get('history')).toEqual []

  describe 'fetching history', ->
    beforeEach ->
      spyOn(@dayHistory.historyQuery, 'run')

    it 'calls to history query with params and callback', ->
      @dayHistory.fetch()
      expect(@dayHistory.historyQuery.run).toHaveBeenCalledWith
        startTime: new Date(@date.sod()).getTime()
        endTime: new Date(@date.eod()).getTime()
        text: ''
      , jasmine.any(Function)
