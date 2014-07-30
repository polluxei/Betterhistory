@BH = BH ? {}
BH.Workers = BH.Workers ? {}

class BH.Workers.RangeSanitizer
  run: (results, @options) ->
    prunedResults = []
    for result in results
      if @verifyDateRange(result)
        result.location = result.url
        result.title ||=  '(No title)'
        @removeScriptTags(result)
        prunedResults.push(result)

    prunedResults.sort(@sortByTime)
    prunedResults

  verifyDateRange: (result) ->
    result.lastVisitTime > @options.startTime && result.lastVisitTime < @options.endTime

  removeScriptTags: (result) ->
    regex = /<(.|\n)*?>/ig
    for property in ['title', 'url', 'location']
      result[property] = result[property].replace(regex, "")

  setAdditionalProperties: (result) ->
    result.location = result.url

  sortByTime: (a, b) ->
    return -1 if a.lastVisitTime > b.lastVisitTime
    return 1 if a.lastVisitTime < b.lastVisitTime
    0

unless onServer?
  self.addEventListener 'message', (e) ->
    sanitizer = new BH.Workers.RangeSanitizer()
    postMessage(sanitizer.run(e.data.results, e.data.options))
