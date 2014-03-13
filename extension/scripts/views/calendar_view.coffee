class BH.Views.CalendarView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Worker

  template: BH.Templates['calendar']

  className: 'calendar_view'

  events:
    'keyup .search': 'onSearchTyped'
    'blur .search': 'onSearchBlurred'

  initialize: ->
    @chromeAPI = chrome

  render: ->
    properties = _.extend @getI18nValues()
    html = Mustache.to_html @template, properties
    @$el.html html
    view = new BH.Views.MonthView
      model: new Backbone.Model(month: 'March', year: '2014')
    @$('.content').html(view.render().el)
    @

  pageTitle: ->
    @t 'calendar_title'

  getI18nValues: ->
    @t [
      'calendar_title',
      'search_input_placeholder_text'
    ]
