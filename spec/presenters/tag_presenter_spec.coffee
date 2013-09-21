describe 'BH.Presenters.TagPresenter', ->
  beforeEach ->
    @site1 =
      title: 'Pound Cake'
      url: 'http://www.atk.com/pound_cake'
      datetime: new Date('1/3/12 5:00 PM').getTime()
    @site2 =
      title: 'Angel Food Cake'
      url: 'http://www.atk.com/angel_food_cake'
      datetime: new Date('1/3/12 7:00 PM').getTime()
    @site3 =
      title: 'Blueberry Muffins'
      url: 'http://www.atk.com/blueberry_muffins'
      datetime: new Date('1/3/13 8:00 PM').getTime()

    attrs =
      name: 'recipes'
      sites: [@site2, @site1, @site3]

    model = new BH.Models.Tag attrs,
      chrome: {}
      persistence: {}

    @presenter = new BH.Presenters.TagPresenter(model)

  describe '#sites', ->
    it 'returns the sites for a tag in descending order', ->
      expect(@presenter.sites()).toEqual
        sites: [@site3, @site2, @site1]
