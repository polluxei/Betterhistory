class BH.Lib.SyncingTranslator
  forServer: (compiledTags, callback, options = {}) ->
    sites = []
    for tag in compiledTags
      for site in tag.sites
        if site.url
          foundIndex = null
          for storedSite, index in sites
            if storedSite.url == site.url
              foundIndex = index
              break
          if foundIndex?
            sites[foundIndex].tags.push tag.name
          else
            site.tags = [tag.name]
            sites.push(site)

    unless options.skipImages
      index = 1
      requestImage = (site) ->
        BH.Lib.ImageData.base64 "chrome://favicon/#{site.url}", (data) ->
          site.image = data
          if index == sites.length
            callback(sites)
          else
            index++

      for site in sites
        requestImage(site)
    else
      callback(sites)

  addImageToSites: (sites, callback) ->
    index = 1
    requestImage = (site) ->
      BH.Lib.ImageData.base64 "chrome://favicon/#{site.url}", (data) ->
        site.image = data
        if index == sites.length
          callback(sites)
        else
          index++

    for site in sites
      requestImage(site)

  forLocal: (sites) ->
    data = tags: []

    for site in sites
      data.tags.push tag for tag in site.tags
    data.tags = _.uniq(data.tags)

    for tag in data.tags
      data[tag] = []

    for site in sites
      site.datetime = new Date().getTime() unless site.datetime?
      for tag in site.tags
        data[tag].push
          url: site.url
          title: site.title
          datetime: site.datetime

    data
