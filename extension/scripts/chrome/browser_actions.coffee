class BH.Chrome.BrowserActions
  constructor: (options = {}) ->
    throw "Chrome API not set" unless options.chrome?
    throw "Tracker not set" unless options.tracker

    @chromeAPI = options.chrome
    @tracker = options.tracker

  listen: ->
    @chromeAPI.browserAction?.onClicked.addListener =>
      @openHistory()

  openHistory: ->
    @tracker.browserActionClick()
    @chromeAPI.tabs.create url: 'chrome://history'
