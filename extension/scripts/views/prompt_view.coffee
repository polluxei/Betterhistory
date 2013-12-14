class BH.Views.PromptView extends BH.Views.ModalView
  @include BH.Modules.I18n

  className: 'prompt_view'

  template: BH.Templates['prompt']

  events:
    'click .no': 'clickedNo'
    'click .yes': 'clickedYes'

  initialize: ->
    @chromeAPI = chrome
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(_.extend(@getI18nValues(), @model.toJSON())))
    @

  clickedNo: (ev) ->
    ev.preventDefault()
    @model.set({action: false})

  clickedYes: (ev) ->
    ev.preventDefault()
    @spin()
    @model.set({action: true})

  spin: ->
    @$el.addClass('loading')

  getI18nValues: ->
    @t [
      'prompt_delete_button',
      'prompt_cancel_button',
      'prompt_title'
    ]

BH.Views.CreatePrompt = (content) ->
  view = new BH.Views.PromptView
    model: new BH.Models.Prompt({content: content})
  $('body').append(view.render().el)
  view

