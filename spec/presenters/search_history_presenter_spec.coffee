describe 'BH.Presenters.SearchHistoryPresenter', ->
  beforeEach ->
    query = 'site bing sunday'
    visits = [
      {
        title: 'site 1'
        name: 'site 1'
        url: 'http://www.google.com/1'
        location: 'http://www.google.com/1'
        date: new Date('December 14, 2013 4:00 PM')
        time: '4:00 PM'
        extendedDate: 'Saturday, December 14th, 2013'
      }, {
        title: 'visit 2'
        name: 'visit 2'
        url: 'http://www.bing.com/2'
        location: 'http://www.bing.com/2'
        date: new Date('December 15, 2013 4:00 PM')
        time: '4:00 PM'
        extendedDate: 'Sunday, December 14th, 2013'
      }, {
        title: 'site 3'
        name: 'site 3'
        url: 'http://www.google.com/3'
        location: 'http://www.google.com/3'
        date: new Date('December 14, 2013 4:00 PM')
        time: '4:00 PM'
        extendedDate: 'Saturday, December 14th, 2013'
      }
    ]
    @presenter =  new BH.Presenters.SearchHistoryPresenter(visits, query)

  describe '#history', ->
    it 'returns the properties for the view template', ->
      expect(@presenter.history(0, 2)).toEqual [
        {
          title: 'site 1'
          name: '<span class="match">site</span> 1'
          url: 'http://www.google.com/1'
          location: 'http://www.google.com/1'
          date: new Date('December 14, 2013 4:00 PM')
          time: '4:00 PM'
          extendedDate: 'Saturday, December 14th, 2013'
        }, {
          title: 'visit 2'
          name: 'visit 2'
          url: 'http://www.bing.com/2'
          location: 'http://www.<span class="match">bing</span>.com/2'
          date: new Date('December 15, 2013 4:00 PM')
          time: '4:00 PM'
          extendedDate: '<span class="match">Sunday</span>, December 14th, 2013'
        }
      ]
