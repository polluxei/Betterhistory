class BH.Presenters.TagsPresenter
  constructor: (collection) ->
    @collection = collection

  tagsSummary: ->
    out = for model in @collection.models
      sites = model.get('sites')
      orderedSites = sites.sort (a,b) ->
        b.datetime - a.datetime

      name: model.get('name')
      count: sites.length
      sites: orderedSites.slice(0, 5)

    tags: out
