class BH.Lib.BrowserActions extends BH.Base
  @include BH.Modules.I18n
  @include BH.Modules.Url

  constructor: ->
    @chromeAPI = chrome

  listen: ->
    @chromeAPI.browserAction.onClicked.addListener =>
      @openHistory()

  openHistory: ->
    track.browserActionClick()
    @chromeAPI.tabs.create
      url: @urlFor()
