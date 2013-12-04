class BH.Lib.Syncer
  updateIfNeeded: (callback = ->) ->
    persistence.remote().userInfo (data) ->
      if data.sites?
        persistence.tag().fetchTags (tags, compiledTags) =>

          if tags.length > 0
            syncingTranslator = new BH.Lib.SyncingTranslator()
            syncingTranslator.forServer compiledTags, (sites) =>

              sitesHasher = new BH.Lib.SitesHasher(CryptoJS.SHA1)
              sites = sitesHasher.generate(sites).toString()

              if sites != data.sites
                persistence.tag().removeAllTags ->
                  persistence.remote().getSites (sites) ->
                    data = syncingTranslator.forLocal sites
                    persistence.tag().import data, ->
                      callback()
