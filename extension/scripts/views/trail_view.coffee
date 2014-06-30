class BH.Views.TrailView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'trail_view'

  template: BH.Templates['trail']

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.append html
    @

  getI18nValues: ->
    @t ['search_input_placeholder_text']
