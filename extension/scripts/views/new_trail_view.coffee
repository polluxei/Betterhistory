class BH.Views.NewTrailView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'new_trail_view'

  template: BH.Templates['new_trail']

  events:
    'click .cancel': 'cancelClicked'
    'click .build_trail': 'buildTrailClicked'
    'keyup [name=trail-matcher]': 'matcherKeyUp'
    'keyup [name=trail-name]': 'nameKeyUp'
    'click [name=add_matcher]': 'addMatcherClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker

    @model = new Backbone.Model
      name: ''
      matchers: []

    @model.on 'change:matchers', @updateMatchers, @

    new BH.Lib.SearchHistory('').fetch maxResults: 5000, (history, cacheDatetime = null) =>
      @historyCache = history

  render: ->
    html = Mustache.to_html @template, @getI18nValues()
    @$el.append html
    @

  matcherKeyUp: (ev) ->
    matcher = $(ev.currentTarget).val()

    matchedHistory = (visit for visit in @historyCache when visit.location.match(matcher))

    matchPreviewView = new BH.Views.TrailMatchPreviewView
      collection: new Backbone.Collection(matchedHistory)
      query: matcher

    @$('.matched_visits').html matchPreviewView.render().el

  nameKeyUp: (ev) ->
    @model.set name: $(ev.currentTarget).val()

  addMatcherClicked: (ev) ->
    $matcherInput = @$('[name=trail-matcher]')
    matcher = $matcherInput.val()
    $matcherInput.val('')

    @$('.matched_visits').html ''

    # bit of a hack, clone arry so backbone thinks its changed
    matchers = _.clone(@model.get('matchers'))
    matchers.push matcher
    @model.set matchers: matchers

  updateMatchers: ->
    @$('.matchers').html "<ul></ul>"
    for matcher in @model.get('matchers')
      @$('.matchers').append "<li><strong>#{matcher}</strong><a href='#' style='float: right;'>Remove</a></li>"

  buildTrailClicked: (ev) ->
    ev.preventDefault()
    @trigger 'build_trail', @model

  getI18nValues: ->
    @t ['search_input_placeholder_text']
