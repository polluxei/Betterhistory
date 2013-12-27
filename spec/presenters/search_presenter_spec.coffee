describe 'BH.Presenters.SearchPresenter', ->
  beforeEach ->
    @presenter = new BH.Presenters.SearchPresenter(query: 'search term')

  describe '#searchInfo', ->
    it 'returns the properties needed for a view template', ->
      expect(@presenter.searchInfo()).toEqual
        title: '[translated searching_title] "search" [translated and] "term"'
        query: 'search term'
