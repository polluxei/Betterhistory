describe 'BH.Models.SearchHistory', ->
  beforeEach ->
    @searchHistory = new BH.Models.SearchHistory
      query: 'search term'

  describe '#toChrome', ->
    it 'returns the reading properties when reading is true', ->
      expect(@searchHistory.toChrome()).toEqual
        text: 'search term'
        searching: true

  describe '#toTemplate', ->
    beforeEach ->
      @searchHistory.set history:
        toTemplate: jasmine.createSpy('toTemplate').andReturn 'templated history'

    it 'returns the properties for the view template', ->
      expect(@searchHistory.toTemplate()).toEqual 'templated history'

  describe 'fetching history', ->
    beforeEach ->
      spyOn(@searchHistory.historyQuery, 'run')

    it 'calls to history query with params and callback', ->
      @searchHistory.fetch()
      expect(@searchHistory.historyQuery.run).toHaveBeenCalledWith
        text: 'search term'
        searching: true
      , jasmine.any(Function)
