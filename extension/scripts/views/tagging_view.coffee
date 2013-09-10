class BH.Views.TaggingView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Url

  template: BH.Templates['tagging']

  className: 'tagging_view'

  events:
    'click #view_history': 'viewHistoryClicked'
    'click #explore_tags': 'exploreTagsClicked'
    'click #search_domain': 'searchDomainClicked'
    'click #add_tag': 'addTagClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @model.on('change:tags', @renderTags, @)

  render: ->
    presenter = new BH.Presenters.SitePresenter(@model)
    html = Mustache.to_html(@template, presenter.site())
    @tracker.popupVisible()
    @$el.html html
    setTimeout =>
      @$('#tag_name').focus()
    , 0
    @

  renderTags: ->
    @activeTagsView.remove() if @activeTagsView
    @activeTagsView = new BH.Views.ActiveTagsView
      model: @model
      tracker: @tracker
    @$('.active_tags').html @activeTagsView.render().el

  viewHistoryClicked: (ev) ->
    ev.preventDefault()
    @tracker.viewAllHistoryPopupClick()
    chrome.tabs.create
      url: $(ev.currentTarget).attr('href')

  exploreTagsClicked: (ev) ->
    ev.preventDefault()
    @tracker.exploreTagsPopupClick()
    chrome.tabs.create
      url: $(ev.currentTarget).attr('href')

  searchDomainClicked: (ev) ->
    ev.preventDefault()
    @tracker.searchByDomainPopupClick()
    chrome.tabs.create
      url: $(ev.currentTarget).attr('href')

  addTagClicked: (ev) ->
    ev.preventDefault()
    $tagName = @$('#tag_name')
    tag = $tagName.val()
    $tagName.val('')
    @tracker.addTagPopup()

    if @model.addTag(tag) == false
      if parent = $("[data-tag='#{tag}']").parents('li')
        parent.addClass('glow')
        setTimeout ->
          parent.removeClass('glow')
        , 1000
