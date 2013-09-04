class BH.Views.TagsListView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'tags_list_view'

  template: BH.Templates['tags_list']

  initialize: ->
    @chromeAPI = chrome

  render: ->
    presenter = new BH.Presenters.TagsPresenter(@collection)
    properties = _.extend presenter.tagsSummary(), @getI18nValues()
    html = Mustache.to_html @template, properties
    @$el.html html
    @

  getI18nValues: ->
    @t ['no_tags_found']
