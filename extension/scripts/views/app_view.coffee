class BH.Views.AppView extends Backbone.View
  @include BH.Modules.I18n

  className: 'app_view'

  template: BH.Templates['app']

  initialize: (options)->
    @chromeAPI = chrome
    @menuView = new BH.Views.MenuView collection: options.trails

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.html html
    @$('.navigation').append @menuView.render().el
    @

  getI18nValues: ->
    @t ['history_title']
