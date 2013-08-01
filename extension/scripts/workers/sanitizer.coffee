@BH = BH ? {}
BH.Workers = BH.Workers ? {}

class BH.Workers.Sanitizer
  run: (results, @options) ->
    if @options.text
      @terms = options.text.split(' ')

    prunedResults = []
    for result in results
      if @options.searching?
        if prunedResults.length >= 1000
          true
        else
          @setAdditionalProperties(result)
          if @verifyTextMatch(result)
            @removeScriptTags(result)
            prunedResults.push(result)
      else
        if @verifyDateRange(result)
          @setAdditionalProperties(result)
          @removeScriptTags(result)
          if @terms && @terms.length != 0
            if @verifyTextMatch(result)
              prunedResults.push(result)
          else
            prunedResults.push(result)

    prunedResults.sort(@sortByTime)
    return prunedResults

  verifyTextMatch: (result) ->
    hits = []
    regExp = null

    for term in @terms
      regExp = new RegExp(term, "i")
      if result.time.match(regExp) ||
         result.extendedDate.match(regExp) ||
         result.url.match(regExp) ||
         result.title.match(regExp)
        hits.push(true)

    if @terms? && hits.length == @terms.length then true else false

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
    sanitizer = new BH.Workers.Sanitizer()
    postMessage(sanitizer.run(e.data.results, e.data.options))
