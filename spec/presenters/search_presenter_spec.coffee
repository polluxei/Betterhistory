describe 'BH.Presenters.SearchPresenter', ->
  beforeEach ->
    model = new BH.Models.Search query: 'search term'
    @presenter = new BH.Presenters.SearchPresenter(model)

  describe '#search', ->
    it 'returns the properties needed for a view template', ->
      expect(@presenter.search()).toEqual
        title: '[translated searching_title] "search" [translated and] "term"'
        query: 'search term'
