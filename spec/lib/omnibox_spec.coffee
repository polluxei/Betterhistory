describe "BH.Lib.Omnibox", ->
  beforeEach ->
    @omnibox = new BH.Lib.Omnibox
      chrome: chrome
      tracker: omniboxSearch: jasmine.createSpy("omniboxSearch")

  describe '#listen', ->
    it 'attaches to input change', ->
      @omnibox.listen()
      expect(chrome.omnibox.onInputEntered.addListener).toHaveBeenCalledWith jasmine.any(Function)

    it 'attaches to input enter', ->
      @omnibox.listen()
      expect(chrome.omnibox.onInputChanged.addListener).toHaveBeenCalledWith jasmine.any(Function)

  describe '#setDefaultSuggestion', ->
    it 'calls to the chrome api to set the suggestion using the text entered', ->
      @omnibox.setDefaultSuggestion('typed value')
      expect(chrome.omnibox.setDefaultSuggestion).toHaveBeenCalledWith
        description: 'Search <match>typed value</match> in history'

  describe '#getActiveTab', ->
    it 'calls to the chrome api to get the active tab in the current window', ->
      callback = ->
      @omnibox.getActiveTab(callback)
      expect(chrome.tabs.query).toHaveBeenCalledWith {active: true, currentWindow: true}, jasmine.any(Function)

  describe '#updateTabURL', ->
    it 'updates the passed tab id\'s url to be BH\'s search page', ->
      @omnibox.updateTabURL(123, 'query')
      expect(chrome.tabs.update).toHaveBeenCalledWith(123, url: 'chrome://history/#search/query')
