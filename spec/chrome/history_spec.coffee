describe "BH.Chrome.History", ->
  beforeEach ->
    @history = new BH.Chrome.History()

  describe "#query", ->
    beforeEach ->
      chrome.history.search.andCallFake (options, callback) ->
        callback [{
          lastVisitTime: new Date('December 10, 2013 4:00 PM').getTime()
        }]

    it "calls to the chrome history search method with the passed options", ->
      @history.query(maxResults: 0, text: '')
      expect(chrome.history.search).toHaveBeenCalledWith {
        maxResults: 0, text: ''
      }, jasmine.any(Function)

    it "adds a translated extendedDate and time to each visit", ->
      @history.query maxResults: 0, text: '', (visits) ->
        expect(visits).toEqual [
          lastVisitTime: 1386712800000
          date: new Date('December 10, 2013 4:00 PM')
          extendedDate: 'translated extended_formal_date'
          time: 'translated local_time'
        ]

  describe "#deleteAll", ->
    it "calls to the chrome history delete all method", ->
      @history.deleteAll()
      expect(chrome.history.deleteAll).toHaveBeenCalledWith jasmine.any(Function)

  describe "#deleteUrl", ->
    it "calls the chrome history delete url method with the passed url", ->
      @history.deleteUrl('http://www.google.com')
      expect(chrome.history.deleteUrl).toHaveBeenCalledWith {url: 'http://www.google.com'}, jasmine.any(Function)

  describe "#deleteRange", ->
    beforeEach ->
      @options =
        startTime: new Date('December 4, 2013').getTime()
        endTime: new Date('December 10, 2013').getTime()

    it "calls the chrome history delete range method with the passed range", ->
      @history.deleteRange @options
      expect(chrome.history.deleteRange).toHaveBeenCalledWith {
        startTime: 1386136800000, endTime: 1386655200000
      }, jasmine.any(Function)
