class BH.Presenters.TagsPresenter
  constructor: (collection) ->
    @collection = collection

  tagsSummary: ->
    out = for tag in @collection.tagOrder
      model = @collection.findWhere(name: tag)

      orderedSites = model.get('sites').sort (a,b) ->
        b.datetime - a.datetime

      name: model.get('name')
      count: model.get('sites').length
      sites: orderedSites.slice(0, 5)

    tags: out
