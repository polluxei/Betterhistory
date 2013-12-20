class BH.Models.Search extends Backbone.Model
  defaults: ->
    query: ''

  validQuery: ->
    @get('query') != ''

  parseAndSet: (data) ->
    visits = new BH.Collections.Visits()

    for visit in data
      visits.add(new BH.Models.Visit(visit))

    @set history: visits
