class BH.Presenters.SearchHistoryPresenter extends BH.Presenters.Base
  constructor: (@visits, @query) ->

  history: (start, end) ->
    out = []
    if start? && end?
      for i in [start...end]
        out.push @markMatches(@visits[i]) if @visits[i]?
    else
      for visit in @visits
        out.push @markMatches(visit)
    out

  markMatches: (visit) ->
    for term in @query.split(' ')
      regExp = new RegExp(term, "i")
      visit.name = wrapMatchInProperty(regExp, visit.title)
      visit.location = wrapMatchInProperty(regExp, visit.url)
    visit

wrapMatchInProperty = (regExp, property) ->
  return unless property
  match = property.match(regExp)
  if match
    property.replace(regExp, '<span class="match">' + match + '</span>')
  else
    property
