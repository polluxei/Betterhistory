class BH.Views.TaggedSitesView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'tagged_sites'

  template: BH.Templates['tagged_sites']

  events:
    'click .delete': 'deleteClicked'

  initialize: ->
    @chromeAPI = chrome

  render: ->
    presenter = new BH.Presenters.TagPresenter(@model)
    properties = _.extend presenter.sites(), @getI18nValues()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  insertTags: ->
    currentTag = @model.get('name')
    persistence = new BH.Persistence.Tag localStore: localStore
    persistence.cached (operations) ->
      $('.site').each ->
        $el = $(this)
        tags = operations.siteTags $el.attr('href')
        if tags.length > 0
          activeTagsView = new BH.Views.ActiveTagsView
            model: new BH.Models.Site(tags: _.without(tags, currentTag))
            editable: false
          $el.find('.active_tags').html activeTagsView.render().el

  deleteClicked: (ev) ->
    ev.preventDefault()
    $el = $(ev.currentTarget)
    @model.removeSite $el.attr('href')
    $el.parents('.visit').remove()


  getI18nValues: ->
    @t ['no_tagged_sites_found']
