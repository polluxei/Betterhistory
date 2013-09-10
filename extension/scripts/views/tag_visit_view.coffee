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
    @model.on('change:tags', @renderTags, @)

  render: ->
    properties = _.extend @getI18nValues(), @model.toJSON()
    @$el.html @renderTemplate(properties)
    setTimeout =>
      @$('#tag_name').focus()
    , 0
    @

  renderTags: ->
    @activeTagsView.remove() if @activeTagsView
    @activeTagsView = new BH.Views.ActiveTagsView
      model: @model
      tracker: analyticsTracker
    @$('.active_tags').html @activeTagsView.render().el

  doneClicked: (ev) ->
    ev.preventDefault()
    @close()

  addTagClicked: (ev) ->
    ev.preventDefault()
    $tagName = @$('#tag_name')
    tag = $tagName.val()
    $tagName.val('')

    if @model.addTag(tag) == false
      if parent = $("[data-tag='#{tag}']").parents('li')
        parent.addClass('glow')
        setTimeout ->
          parent.removeClass('glow')
        , 1000

  getI18nValues: ->
    []
