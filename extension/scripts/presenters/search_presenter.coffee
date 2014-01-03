class BH.Presenters.SearchPresenter extends BH.Presenters.Base
  constructor: (@search) ->

  searchInfo: ->
    @terms = []
    @terms = @search.query.split(' ') if @search.query?
    joined = @t('searching_title') + ' '

    # yuck
    for term, i in @terms
      joined += "\"#{term}\""
      if i != @terms.length - 1
        joined += " #{@t('and')} "

     _.extend @search, title: joined
