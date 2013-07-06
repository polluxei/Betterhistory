describe "BH.Lib.HistoryQuery", ->
  beforeEach ->
    @callback = jasmine.createSpy("@callback")
    @historyQuery = new BH.Lib.HistoryQuery()
    @chromeAPI = @historyQuery.chromeAPI

  describe "#run", ->
    beforeEach ->
      @options = {text: 'search term'}

    describe "when searching is not set on the options", ->
      it "calls to chrome history API with the passed options and a @callback", ->
        @historyQuery.run(@options, @callback)
        expectedOptions = _.extend {}, @options, maxResults: 5000
        expect(@chromeAPI.history.search).toHaveBeenCalledWith(expectedOptions, jasmine.any(Function))

    describe "when searching is set in the options", ->
      beforeEach ->
        @options = {searching: true, text: 'the search'}

      it "calls to chrome history API with the searching property option removed, search options added, and @callback", ->
        @historyQuery.run(@options, @callback)
        searchOptions = {}
        _.extend(searchOptions, @options, @historyQuery.searchOptions)
        delete searchOptions.searching
        expect(@chromeAPI.history.search).toHaveBeenCalledWith(searchOptions, jasmine.any(Function))

  describe "#searchHandler", ->
    results = null

    beforeEach ->
      @options = text: 'value'
      results = [
        {url: 'google.com', lastVisitTime: 'May 5 2010'},
        {url: 'yahoo.com', lastVisitTime: 'May 6 2010'}
      ]
      @historyQuery.run(@options, @callback)
      spyOn(@historyQuery, 'worker')

    it 'starts the sanitize worker with options, prepared results and a @callback', ->
      @historyQuery.searchHandler(results, @callback)
      expectedOptions = {
        options: @options,
        results: [
          {
            url: 'google.com',
            lastVisitTime: 'May 5 2010',
            date: new Date('May 5 2010')
            extendedDate: 'translated extended_formal_date'
            time: 'translated local_time'
          },
          {
            url: 'yahoo.com',
            lastVisitTime: 'May 6 2010',
            date: new Date('May 6 2010')
            extendedDate: 'translated extended_formal_date'
            time: 'translated local_time'
          }
        ]
      }
      expect(@historyQuery.worker).toHaveBeenCalledWith('sanitizer', expectedOptions, @callback)
