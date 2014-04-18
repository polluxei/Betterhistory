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
    @site10 =
      title: 'baking 101'
      url: 'http://www.atk.com/baking_101'
      datetime: new Date('1/3/10 8:00 PM').getTime()
    @site11 =
      title: 'baking 102'
      url: 'http://www.atk.com/baking_102'
      datetime: new Date('1/3/10 7:00 PM').getTime()
    @site12 =
      title: 'baking 103'
      url: 'http://www.atk.com/baking_103'
      datetime: new Date('1/3/10 6:00 PM').getTime()
    @site13 =
      title: 'baking 104'
      url: 'http://www.atk.com/baking_104'
      datetime: new Date('1/3/10 5:00 PM').getTime()
    @site14 =
      title: 'baking 105'
      url: 'http://www.atk.com/baking_105'
      datetime: new Date('1/3/10 4:00 PM').getTime()

    attrs = [{
      name: 'recipes'
      sites: [@site2, @site1, @site3, @site5, @site4, @site6, @site10, @site11, @site12, @site13, @site14]
    }, {
      name: 'cooking'
      sites: [@site8, @site9, @site7]
    }]

    collection = new BH.Collections.Tags [],
      persistence: {}

    collection.add attrs, persistence: {}
    collection.tagOrder = ['recipes', 'cooking']

    @presenter = new BH.Presenters.TagsPresenter(collection)

  describe '#tagsSummary', ->
    it 'returns all the tags with a summary of their sites', ->
      expect(@presenter.tagsSummary()).toEqual [{
          name: 'recipes'
          count: 11
          sites: [@site6, @site3, @site5, @site2, @site1, @site4, @site10, @site11, @site12, @site13]
        }, {
          name: 'cooking'
          count: 3
          sites: [@site9, @site7, @site8]
        }]

    it 'returns all the tags with a summary of their sites orders by the tag order', ->
      @presenter.collection.tagOrder = ['cooking', 'recipes']
      expect(@presenter.tagsSummary()).toEqual [{
          name: 'cooking'
          count: 3
          sites: [@site9, @site7, @site8]
        }, {
          name: 'recipes'
          count: 11
          sites: [@site6, @site3, @site5, @site2, @site1, @site4, @site10, @site11, @site12, @site13]
        }]

  describe '#selectedAndUnselectedTagsforSites', ->
    beforeEach ->
      @sites = [
        {
          title: 'Pan Frying'
          url: 'http://www.atk.com/pan_frying'
        }, {
          title: 'Preparing Meat'
          url: 'http://www.atk.com/preparing_meat'
        }
      ]

    it 'returns all the tags with the currently tagged sites marked', ->
      results = @presenter.selectedAndUnselectedTagsforSites(@sites)
      expect(results).toEqual [
        {
          name: 'recipes'
          tagged: false
        }, {
          name: 'cooking'
          tagged: true
        }
      ]

