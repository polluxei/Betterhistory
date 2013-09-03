class BH.Lib.Omnibox extends BH.Base
  @include BH.Modules.Url

  constructor: (options = {})->
    throw "Chrome API not set" unless options.chrome?
    throw "Tracker not set" unless options.tracker?

    @chromeAPI = options.chrome
    @tracker = options.tracker

  listen: ->
    @chromeAPI.omnibox?.onInputChanged.addListener (text, suggest) =>
      @setDefaultSuggestion(text)

    @chromeAPI.omnibox?.onInputEntered.addListener (text) =>
      @tracker.omniboxSearch()
      @getActiveTab (tabId) => @updateTabURL(tabId, text)

  setDefaultSuggestion: (text) ->
    @chromeAPI.omnibox?.setDefaultSuggestion
      description: "Search <match>#{text}</match> in history"

  getActiveTab: (callback) ->
    @chromeAPI.tabs.query {active: true, currentWindow: true}, (tabs) ->
      callback(tabs[0].id)

  updateTabURL: (tabId, text) ->
    @chromeAPI.tabs.update tabId, url: @urlFor('search', text, absolute: true)
