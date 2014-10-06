class BH.Views.SearchResultsView extends Backbone.View
  @include BH.Modules.I18n

  template: BH.Templates['search_results']

  events:
    'click .delete_visit': 'deleteClicked'
    'click .delete_download': 'deleteDownloadClicked'

  initialize: ->
    @page = @options.page
    @collection.on 'add', @onVisitAdded, @
    @page.on 'change:page', @onPageChange, @

  render: ->
    [start, end] = BH.Lib.Pagination.calculateBounds(@page.get('page') - 1)

    presenter = new BH.Presenters.SearchHistoryPresenter(@collection.toJSON(), @options.query)

    properties = _.extend @getI18nValues(),
      visits: presenter.history(start, end)
      extendSearch: @page.get('totalPages') == @page.get('page') && !@options.deepSearched

    html = Mustache.to_html @template, properties
    @$el.html html

    @show()
    @inflateDates()
    @inflateDownloadIcons()

    document.body.scrollTop = 0

    @

  resetRender: ->
    @hide()
    setTimeout (=> @$('.visits_content').html ''), 250

  show: ->
    @$el.removeClass('disappear')

  hide: ->
    @$el.addClass('disappear')

  inflateDates: ->
    [start, end] = BH.Lib.Pagination.calculateBounds(@page.get('page') - 1)
    presenter = new BH.Presenters.SearchHistoryPresenter(@collection.toJSON(), @options.query)
    history = presenter.history(start, end)

    $('.visit .datetime').each (i, el) =>
      @inflateDate $(el), history[i].lastVisitTime || history[i].startTime

  inflateDate: ($el, timestamp) ->
    $el.text new Date(timestamp).toLocaleString(BH.lang)

  inflateDownloadIcons: ->
    callback = (el, uri) ->
      $(el).find('.description').css backgroundImage: "url(#{uri})"

    $('.download').each (i, el) =>
      downloadId = parseInt($(el).data('download-id'), 10)
      chrome.downloads.getFileIcon downloadId, {}, (uri) ->
        callback(el, uri)

  deleteClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    url = $el.data('url')

    Historian.deleteUrl url, =>
      $el.parents('.visit').remove()
      @collection.remove @collection.where(url: url)
      new Historian.Search().expireCache()
      window.analyticsTracker.searchResultDeletion()

  deleteDownloadClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    url = $el.data('url')

    Historian.deleteDownload url, =>
      $el.parents('.visit').remove()
      @collection.remove @collection.where(url: url)
      new Historian.Search().expireCache()
      window.analyticsTracker.searchResultDeletion()

  onVisitAdded: (model) ->
    if $('.visits li').length < 100
      visitView = new BH.Views.VisitView model: model
      @$('.visits').append visitView.render().el

      @inflateDate visitView.$('.datetime'), model.get('lastVisitTime')

  onPageChange: ->
    @render()

  getI18nValues: ->
    @t [
      'no_visits_found'
      'prompt_delete_button'
    ]
