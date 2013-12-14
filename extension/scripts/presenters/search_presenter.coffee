class BH.Presenters.SearchPresenter extends BH.Presenters.Base
  constructor: (@model) ->

  search: ->
    @terms = @model.get('query').split(' ')
    joined = @t('searching_title') + ' '

    # yuck
    for term, i in @terms
      joined += "\"#{term}\""
      if i != @terms.length - 1
        joined += " #{@t('and')} "

     _.extend @model.toJSON(), title: joined
