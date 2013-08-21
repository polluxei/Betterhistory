describe "BH.Lib.BrowserActions", ->
  beforeEach ->
    @browserActions = new BH.Lib.BrowserActions
      chrome: chrome
      tracker: browserActionClick: jasmine.createSpy()

  describe "#listen", ->
    it "listens for onClick on the browser action", ->
      @browserActions.listen()
      expect(chrome.browserAction.onClicked.addListener).toHaveBeenCalledWith jasmine.any(Function)

  describe "#openHistory", ->
    it "opens history in a new tab", ->
      @browserActions.openHistory()
      expect(chrome.tabs.create).toHaveBeenCalledWith url: 'chrome://history/'
