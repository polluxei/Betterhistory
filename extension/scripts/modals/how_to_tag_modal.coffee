class BH.Modals.HowToTagModal extends BH.Modals.Base
  @include BH.Modules.I18n

  className: 'how_to_tag_view'
  template: BH.Templates['how_to_tag']

  events:
    'click .done': 'doneClicked'

  initialize: ->
    @chromeAPI = chrome
    @attachGeneralEvents()

  render: ->
    @$el.html(@renderTemplate(@getI18nValues()))
    @on 'open', ->
      !(->
        n = ->
          n = document.getElementsByName('quickcast')
          for e in n
            t = e.offsetWidth
            e.height=t/0.91+'px'
        n()
        window.onresize=n
        window.addEventListener('message',(n) ->
          if(n.data.indexOf('//quick.as/') != -1)
            window.location.href=n.data
        ,!1)
      )()
    , @

    return this

  doneClicked: (ev) ->
    ev.preventDefault()
    @close()

  getI18nValues: ->
    @t ['how_to_tag_title', 'prompt_done_button']
