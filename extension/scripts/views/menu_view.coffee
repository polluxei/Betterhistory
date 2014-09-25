class BH.Views.MenuView extends Backbone.View
  @include BH.Modules.I18n

  className: 'menu_view'

  template: BH.Templates['menu']

  initialize: ->
    @collection.on 'add', @render, @

  render: ->
    properties = _.extend {}, @getI18nValues(), trails: @collection.toJSON()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  select: (selector) ->
    @$('.menu > *').removeClass 'selected'
    @$(selector).parent().addClass 'selected'

  getI18nValues: ->
    @t ['settings_link', 'tags_link', 'devices_link', 'search_link']
