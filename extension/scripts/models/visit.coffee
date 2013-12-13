class BH.Models.Visit extends Backbone.Model
  defaults:
    title: '(No Title)'

  initialize: ->
    @chromeAPI = chrome

    @set id: @cid
    @set(title: @defaults.title) if @get('title') == ''

  sync: (method, model, options) ->
    if method == 'delete'
      @chromeAPI.history.deleteUrl({url: @get('url')})
      options.success(@)

  domain: ->
    match = @_getDomain @get('url')
    if match == null then null else match[0]

  path: () ->
    if @_getDomain(@get('url'))?
      @get('url').replace(@_getDomain(@get('url'))[0], '')

  _getDomain: (url) ->
    url.match(/\w+:\/\/(.*?)\//)
