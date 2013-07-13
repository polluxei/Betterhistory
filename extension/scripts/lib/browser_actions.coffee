class BH.Lib.BrowserActions extends BH.Base
  @include BH.Modules.I18n
  @include BH.Modules.Url

  constructor: ->
    @chromeAPI = chrome

  listen: ->
    @chromeAPI.browserAction.onClicked.addListener =>
      @openHistory()

  openHistory: ->
    @chromeAPI.tabs.create
      url: @urlFor()
