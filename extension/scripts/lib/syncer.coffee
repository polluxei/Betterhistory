class BH.Lib.Syncer
  updateIfNeeded: (callback = ->) ->
    persistence.remote().userInfo (data) ->
      if data.sites?
        persistence.tag().getSitesHash (localData) ->
          if data.sites != localData.sitesHash
            persistence.remote().getSites (sites) ->
              syncingTranslator = new BH.Lib.SyncingTranslator()
              data = syncingTranslator.forLocal sites
              persistence.tag().import data, ->
                callback()
