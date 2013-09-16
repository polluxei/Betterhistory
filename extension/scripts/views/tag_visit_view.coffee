class BH.Views.TagVisitView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'tag_visit_view'
  template: BH.Templates['tag_visit']

  events:
    'click .done': 'doneClicked'
    'click #add_tag': 'addTagClicked'

  initialize: ->
    @chromeAPI = chrome
    @attachGeneralEvents()
    @collection.on('change:allTags', @renderTags, @)

  render: ->
    properties = _.extend @getI18nValues(), sites: @collection.toJSON()
    @$el.html @renderTemplate(properties)
    setTimeout =>
      @$('#tag_name').focus()
    , 0
    @

  renderTags: ->
    @activeTagsView.remove() if @activeTagsView
    @activeTagsView = new BH.Views.ActiveTagsView
      model: @collection
      tracker: analyticsTracker
    @$('.active_tags').html @activeTagsView.render().el

  doneClicked: (ev) ->
    ev.preventDefault()
    @close =>
      @trigger 'close'

  addTagClicked: (ev) ->
    ev.preventDefault()
    $tagName = @$('#tag_name')
    tag = $tagName.val()
    $tagName.val('')

    if @collection.addTag(tag) == false
      if parent = $("[data-tag='#{tag}']").parents('li')
        parent.addClass('glow')
        setTimeout ->
          parent.removeClass('glow')
        , 1000

  getI18nValues: ->
    @t ['tag_visits_title', 'shared_visits_tags_title', 'prompt_done_button']
