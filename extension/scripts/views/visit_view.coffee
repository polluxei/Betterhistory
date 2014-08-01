class BH.Views.VisitView extends Backbone.View
  @include BH.Modules.I18n

  className: 'visit_view'
  template: BH.Templates['visit']

  render: ->
    html = Mustache.to_html @template, @model.toJSON()
    @$el.html html
    @
