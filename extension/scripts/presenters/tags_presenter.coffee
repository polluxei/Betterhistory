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

    out

  selectedAndUnselectedTagsforSites: (sites) ->
    for tag in @collection.tagOrder
      model = @collection.findWhere(name: tag)

      for site in sites
        result = _.find model.get('sites'), (taggedSite) ->
          taggedSite.url == site.url
        if result?
          site.tags = [] unless site.tags
          site.tags.push(model.get('name'))

    commonTags = _.intersection.apply(_, _.pluck(sites, 'tags'))

    for tag in @collection.tagOrder
      model = @collection.findWhere(name: tag)

      name: model.get('name')
      tagged: commonTags.indexOf(model.get('name')) != -1
