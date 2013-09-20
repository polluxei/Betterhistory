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
    properties = @t ['no_tags_found', 'about_tags_title']
    properties.i18n_about_tags_instructions = @t 'about_tags_instructions', [
      '<a href="#" class="how_to_tag">', '</a>'
    ]
    properties.i18n_extra_tag_help = @t 'extra_tag_help', [
      '<a href="#" class="how_to_tag">', '</a>',
      '<a href="#" class="load_example_tags">', '</a>'
    ]
    properties
