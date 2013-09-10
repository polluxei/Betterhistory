describe 'BH.Presenters.SitePresenter', ->
  beforeEach ->
    attrs =
      title: 'Google',
      url: 'http://www.google.com'

    model = new BH.Models.Site attrs,
      chrome: {}
      persistence: {}

    @presenter = new BH.Presenters.SitePresenter(model)

  describe '#site', ->
    it 'returns the properties with an added domain', ->
      expect(@presenter.site()).toEqual
        title: 'Google'
        url: 'http://www.google.com'
        domain: 'google.com'

    it 'does not strip the subdomain if it is something other than www', ->
      @presenter.model.set url: 'http://test.google.com'
      expect(@presenter.site()).toEqual
        title: 'Google'
        url: 'http://test.google.com'
        domain: 'test.google.com'
