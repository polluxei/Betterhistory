describe 'BH.Models.WeekHistory', ->
  beforeEach ->
    @startDate = moment(new Date('October 11, 2012'))
    @endDate = moment(new Date('October 17, 2012'))
    @weekHistory = new BH.Models.WeekHistory
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

  describe '#toChrome', ->
    it 'returns the reading properties when reading is true', ->
      expect(@weekHistory.toChrome()).toEqual
        startTime: new Date(@startDate.sod()).getTime()
        endTime: new Date(@endDate.eod()).getTime()
        text: ''

    it 'returns the deleting properties when reading is false', ->
      expect(@weekHistory.toChrome(false)).toEqual
        startTime: new Date(@startDate.sod()).getTime()
        endTime: new Date(@endDate.eod()).getTime()

  describe 'deleting history', ->
    beforeEach ->
      @deleteRange = @weekHistory.chromeAPI.history.deleteRange
      @deleteRange.andCallFake (options, callback) ->
        callback()

    it 'calls to the history delete method with params and callback', ->
      @weekHistory.destroy()
      expect(@deleteRange).toHaveBeenCalledWith
        startTime: new Date(@startDate.sod()).getTime()
        endTime: new Date(@endDate.eod()).getTime()
      , jasmine.any(Function)

    it 'resets the history', ->
      @weekHistory.destroy()
      expect(@weekHistory.get('history')).toEqual []

  describe 'fetching history', ->
    beforeEach ->
      spyOn(@weekHistory.historyQuery, 'run')

    it 'calls to history query with params and callback', ->
      @weekHistory.fetch()
      expect(@weekHistory.historyQuery.run).toHaveBeenCalledWith
        startTime: new Date(@startDate.sod()).getTime()
        endTime: new Date(@endDate.eod()).getTime()
        text: ''
      , jasmine.any(Function)
