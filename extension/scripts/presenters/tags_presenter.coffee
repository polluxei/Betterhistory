class BH.Presenters.TagsPresenter
  constructor: (collection) ->
    @collection = collection

  tagsSummary: ->
    out = []
    for tag in @collection.tagOrder
      model = @collection.findWhere(name: tag)

      if model?
        orderedSites = model.get('sites').sort (a,b) ->
          b.datetime - a.datetime

        out.push
          name: model.get('name')
          count: model.get('sites').length
          sites: orderedSites.slice(0, 10)

    tags: out

  selectedAndUnselectedTagsforSites: (sites) ->
    out = for tag in @collection.tagOrder
      model = @collection.findWhere(name: tag)

      orderedSites = model.get('sites').sort (a,b) ->
        b.datetime - a.datetime

      tagged = false
      for site in sites
        result = _.find model.get('sites'), (taggedSite) ->
          taggedSite.url == site.url

        if result?
          tagged = true
          break

      name: model.get('name')
      tagged: tagged

    tags: out
