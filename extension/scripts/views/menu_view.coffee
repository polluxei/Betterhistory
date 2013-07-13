class BH.Views.MenuView extends Backbone.View
  template: BH.Templates['menu']

  events:
    'click .menu > *': 'weekClicked'

  render: ->
    html = Mustache.to_html @template, @collection.toTemplate()
    @$el.html html

  weekClicked: (ev) ->
    @$('.menu > *').removeClass 'selected'
    $(ev.currentTarget).addClass 'selected'
