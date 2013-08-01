describe "BH.Workers.Sanitizer", ->
  beforeEach ->
    @visits = []
    @sanitizer = new BH.Workers.Sanitizer()

  it "returns a max of 1000 results when searching", ->
    a = 0

    while a < 1001
      @visits.push
        title: "title"
        url: "google.com"
        lastVisitTime: new Date()
        extendedDate: 'the extended date'
        time: 'Monday, July 4th, 2010'
      a++

    options =
      text: 'title'
      searching: true

    sanitizedVisits = @sanitizer.run(@visits, options)
    expect(sanitizedVisits.length).toEqual(1000)

  it "returns as many results as found when filtering by date", ->
    a = 0

    while a < 150
      @visits.push
        title: "title"
        url: "google.com"
        lastVisitTime: new Date("December 5, 2011 12:00")
        extendedDate: 'the extended date'
        time: 'December 5, 2011 12:00'
      a++

    options =
      startTime: new Date("December 5, 2011 0:00")
      endTime: new Date("December 5, 2011 23:59")

    sanitizedVisits = @sanitizer.run(@visits, options)
    expect(sanitizedVisits.length).toEqual(150)

  describe "Additional properties", ->
    it "sets a property called location to be equal to the url", ->
      @visits = [
        title: "testing"
        url: "gooogle.com"
        lastVisitTime: new Date("October 12, 2010")
      ]

      options =
        startTime: new Date("October 1, 2010")
        endTime: new Date("October 14, 2010")

      sanitizedVisits = @sanitizer.run(@visits, options)
      expect(sanitizedVisits[0].location).toEqual(@visits[0].url)

  describe "Removing script tags", ->
    it "removes any script tags in the title", ->
      @visits = [
        title: "test<script>alert(\"yo\")</script>"
        url: "yahoo.com"
        lastVisitTime: new Date("September 12, 2010")
        extendedDate: 'the extended date'
        time: 'the time'
      ]

      options =
        text: "test"
        searching: true

      sanitizedVisits = @sanitizer.run(@visits, options)
      expect(sanitizedVisits[0].title).toEqual("testalert(\"yo\")")

    it "removes any script tags in the url", ->
      @visits = [
        title: "test"
        url: "yahoo.com<script>alert(\"yo\")</script>"
        lastVisitTime: new Date("September 12, 2010")
        extendedDate: 'the extended date'
        time: 'the time'
      ]

      options =
        text: "yahoo"
        searching: true

      sanitizedVisits = @sanitizer.run(@visits, options)
      expect(sanitizedVisits[0].location).toEqual("yahoo.comalert(\"yo\")")

  it "matches results by checking if the search term exists in the title, url, time, or date of the visit", ->
    visit1 =
      title: "September something"
      url: "google.com"
      lastVisitTime: new Date("December 2, 2010")
      extendedDate: 'the extended date'
      time: '12:30PM'

    visit2 =
      title: "Normal something"
      url: "google.com/september"
      lastVisitTime: new Date("July 2, 2010")
      extendedDate: 'the extended date'
      time: '12:30PM'

    visit3 =
      title: "something"
      url: "yahoo.com"
      lastVisitTime: new Date("September 12, 2010")
      extendedDate: 'September'
      time: '12:30PM'

    @visits = [
      title: "hit september"
      url: "google.com"
      extendedDate: 'the extended date'
      time: 'the time'
      , visit1,
      title: "lame"
      url: "google.com/hit"
      extendedDate: 'the extended date'
      time: 'the time'
      , visit2,
      title: "no match"
      url: "google.com/something"
      extendedDate: 'the extended date'
      time: 'the time'
      , visit3
    ]

    options =
      searching: true
      text: "september something 12:30PM"

    sanitizedVisits = @sanitizer.run(@visits, options)
    expect(sanitizedVisits).toEqual([visit1, visit3, visit2])

  it "orders the matched results by lastVisitTime", ->
    visit1 =
      title: "news"
      url: "google.com"
      lastVisitTime: new Date("September 12, 2010 4:00")
      extendedDate: 'the extended date'
      time: 'the time'

    visit2 =
      title: "news"
      url: "google.com"
      lastVisitTime: new Date("July 2, 2011")
      extendedDate: 'the extended date'
      time: 'the time'

    visit3 =
      title: "news"
      url: "yahoo.com"
      lastVisitTime: new Date("September 12, 2010 12:00")
      extendedDate: 'the extended date'
      time: 'the time'

    visit4 =
      title: "news"
      url: "yahoo.com"
      lastVisitTime: new Date("September 12, 2010 2:00")
      extendedDate: 'the extended date'
      time: 'the time'

    @visits = [
      title: "hit this"
      url: "google.com"
      extendedDate: 'the extended date'
      time: 'the time'
      , visit1,
      title: "lame"
      url: "google.com/hit"
      extendedDate: 'the extended date'
      time: 'the time'
      , visit2,
      title: "no match"
      url: "google.com"
      extendedDate: 'the extended date'
      time: 'the time'
      , visit3, visit4
    ]

    options =
      text: "news"
      searching: true

    sanitizedVisits = @sanitizer.run(@visits, options)
    expect(sanitizedVisits).toEqual([visit2, visit3, visit1, visit4])

  it "matches results by checking if the date falls between the searched ranges", ->
    visit1 =
      title: "google"
      url: "google.com"
      lastVisitTime: new Date("October 12, 2010")
      extendedDate: 'the extended date'
      time: 'the time'

    visit2 =
      title: "sample"
      url: "google.com/sample"
      lastVisitTime: new Date("October 13, 2010")
      extendedDate: 'the extended date'
      time: 'the time'

    @visits = [
      visit1,
      title: "hit"
      url: "google.com/hit"
      lastVisitTime: new Date("December 5, 2010")
      extendedDate: 'the extended date'
      time: 'the time'
      , visit2
    ]

    options =
      startTime: new Date("October 1, 2010")
      endTime: new Date("October 14, 2010")

    sanitizedVisits = @sanitizer.run(@visits, options)
    expect(sanitizedVisits).toEqual([visit2, visit1])
