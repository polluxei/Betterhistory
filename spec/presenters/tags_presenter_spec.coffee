describe 'BH.Presenters.TagsPresenter', ->
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
    @site4 =
      title: 'Chocolate Cake'
      url: 'http://www.atk.com/chocolate_cake'
      datetime: new Date('1/3/11 5:00 PM').getTime()
    @site5 =
      title: 'Key Lime Pie'
      url: 'http://www.atk.com/key_lime_pie'
      datetime: new Date('1/5/12 1:00 PM').getTime()
    @site6 =
      title: 'Peach Cobbler'
      url: 'http://www.atk.com/peach_cobbler'
      datetime: new Date('2/2/13 8:00 PM').getTime()
    @site7 =
      title: 'Pan Frying'
      url: 'http://www.atk.com/pan_frying'
      datetime: new Date('1/3/13 5:00 PM').getTime()
    @site8 =
      title: 'Baking'
      url: 'http://www.atk.com/baking'
      datetime: new Date('1/5/12 1:00 PM').getTime()
    @site9 =
      title: 'Preparing Meat'
      url: 'http://www.atk.com/preparing_meat'
      datetime: new Date('2/2/13 8:00 PM').getTime()

    attrs = [{
      name: 'recipes'
      sites: [@site2, @site1, @site3, @site5, @site4, @site6]
    }, {
      name: 'cooking'
      sites: [@site8, @site9, @site7]
    }]

    collection = new BH.Collections.Tags [],
      persistence: {}

    collection.add attrs, persistence: {}

    @presenter = new BH.Presenters.TagsPresenter(collection)

  describe '#tagsSummary', ->
    it 'returns all the tags with a summary of their sites', ->
      expect(@presenter.tagsSummary()).toEqual
        tags: [{
          name: 'recipes'
          count: 6
          sites: [@site6, @site3, @site5, @site2, @site1]
        }, {
          name: 'cooking'
          count: 3
          sites: [@site9, @site7, @site8]
        }]
