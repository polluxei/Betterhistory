class BH.Lib.TagSyncingFormatter
  constructor: (@localStore) ->

  fetchAndFormat: (callback) ->
    sites = []

    formatted = (sites) ->
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

    fetchSitesForTag = (tag, callback) ->
      persistence.fetchTagSites tag, (data) ->
        for site in data
          if site.url
            foundIndex = null
            for storedSite, index in sites
              if storedSite.url == site.url
                foundIndex = index
                break
            if foundIndex?
              sites[foundIndex].tags += ", #{tag}"
            else
              site.tags = tag
              sites.push(site)

        callback()

    persistence = new BH.Persistence.Tag(localStore: @localStore)
    persistence.fetchTags (tags) ->
      index = 1
      for tag in tags
        fetchSitesForTag tag, ->
          if index == tags.length
            formatted(sites)
          else
            index++
