class BH.Lib.DayHistory
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @history = new BH.Chrome.History()
    @worker = BH.Modules.Worker.worker

  fetch: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime
      text: ''
      maxResults: 5000

    @history.query options, (results) =>
      options =
        options: options
        results: results

      @worker 'rangeSanitizer', options, (sanitizedResults) =>
        options =
          visits: sanitizedResults
          interval: settings.get('timeGrouping')

        @worker 'timeGrouper', options, (history) =>
          if settings.get('domainGrouping')
            options = intervals: history
            @worker 'domainGrouper', options, (history) =>
              callback parse(history)
          else
            callback parse(history)

  destroy: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime

    @history.deleteRange options, =>
      callback()

parse = (intervals) ->
  out = []
  for interval in intervals
    visits = []
    for visit in interval.visits
      item = if _.isArray(visit)
        fillInGroupedVisit(visit)
      else
        fillInVisit(visit)

      visits.push item

    out.push
      id: interval.id
      datetime: interval.datetime
      visits: visits

  out

getDomain = (url) ->
  match = url.match(/\w+:\/\/(.*?)\//)
  if match == null then null else match[0]

fillInVisit = (visit) ->
  visit.domain = getDomain(visit.url)
  visit.host = getDomain(visit.url)
  visit.path = visit.url.replace(visit.domain, '')
  visit

fillInGroupedVisit = (visits) ->
  visits = for visit in visits
    fillInVisit(visit)

  visit = visits[0]

  groupedVisit =
    host: visit.domain
    domain: visit.domain
    url: visit.url
    time: visits.time
    isGrouped: true
    visits: visits
