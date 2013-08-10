describe "BH.Lib.Omnibox", ->
  beforeEach ->
    @omnibox = new BH.Lib.Omnibox()
    @chromeAPI = @omnibox.chromeAPI

  describe '#listen', ->
    it 'attaches to input change', ->
      @omnibox.listen()
      expect(@chromeAPI.omnibox.onInputEntered.addListener).toHaveBeenCalledWith jasmine.any(Function)

    it 'attaches to input enter', ->
      @omnibox.listen()
      expect(@chromeAPI.omnibox.onInputChanged.addListener).toHaveBeenCalledWith jasmine.any(Function)

  describe '#setDefaultSuggestion', ->
    it 'calls to the chrome api to set the suggestion using the text entered', ->
      @omnibox.setDefaultSuggestion('typed value')
      expect(@chromeAPI.omnibox.setDefaultSuggestion).toHaveBeenCalledWith
        description: 'Search <match>typed value</match> in history'

  describe '#getActiveTab', ->
    it 'calls to the chrome api to get the active tab in the current window', ->
      callback = ->
      @omnibox.getActiveTab(callback)
      expect(@chromeAPI.tabs.query).toHaveBeenCalledWith {active: true, currentWindow: true}, jasmine.any(Function)

  describe '#updateTabURL', ->
    it 'updates the passed tab id\'s url to be BH\'s search page', ->
      @omnibox.updateTabURL(123, 'query')
      expect(@chromeAPI.tabs.update).toHaveBeenCalledWith(123, url: 'chrome://history/#search/query')
