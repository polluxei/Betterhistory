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

    if @search.filter?.week
      date = moment(new Date(@search.filter.week)).format('L')
      @search.filterName = "Week of #{date}"
    else if @search.filter?.day
      date = moment(new Date(@search.filter.day)).format('L')
      @search.filterName = date

    _.extend @search, title: joined
