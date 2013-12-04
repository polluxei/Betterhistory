class BH.Views.TaggingView extends BH.Views.MainView
  @include BH.Modules.I18n
  @include BH.Modules.Url

  template: BH.Templates['tagging']

  className: 'tagging_view'

  events:
    'click #view_history': 'viewHistoryClicked'
    'click #explore_tags': 'exploreTagsClicked'
    'click #search_domain': 'searchDomainClicked'
    'click #tag_details': 'tagDetailsClicked'
    'click .dismiss_instructions': 'dismissInstructionsClicked'
    'click #add_tag': 'addTagClicked'

  initialize: ->
    @chromeAPI = chrome
    @tracker = @options.tracker
    @model.on('reset:tags', @renderTags, @)

  render: ->
    @getShortcut (commands) =>
      presenter = new BH.Presenters.SitePresenter(@model)

      properties = _.extend presenter.site(), @getI18nValues()
      properties.i18n_search_domain_history_link = @t 'search_domain_history_link', [properties.domain]
      if commands?
        properties.shortcut = _.where(commands, name: '_execute_browser_action')[0].shortcut
      _.extend properties, tagState.toJSON()

      html = Mustache.to_html(@template, properties)
      @tracker.popupVisible()
      @$el.html html
      @$('.links a').each (i) ->
        $(@).attr 'tabindex', i
      setTimeout =>
        @$('#tag_name').focus()
      , 0
      @

  getShortcut: (callback) ->
    if @chromeAPI.commands?.getAll?
      @chromeAPI.commands.getAll (commands) =>
        callback(commands)
    else
      callback()

  renderTags: ->
    @autocompleteTagsView.remove() if @autocompleteTagsView
    @autocompleteTagsView = new BH.Views.AutocompleteTagsView
      model: @model
      collection: @collection
      tracker: @tracker
    @$('.autocomplete').html @autocompleteTagsView.render().el
    @collection.fetch()


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

  tagDetailsClicked: (ev) ->
    ev.preventDefault()
    @tracker.tagDetailsPopupClick()
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

  dismissInstructionsClicked: (ev) ->
    ev.preventDefault()
    syncStore.set tagInstructionsDismissed: true
    $('.about_tags').hide()


  getI18nValues: ->
    properties = @t ['view_all_history_link', 'explore_tags_link']
    properties.i18n_about_tags_for_popup = @t 'about_tags_for_popup', [
      '<span class="new">', '</span>', '<a id="tag_details" href="chrome://history/#tags">', '</a>'
    ]
    properties
