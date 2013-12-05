class BH.Lib.Syncer
  updateIfNeeded: (callback = ->) ->
    persistence.remote().sitesHash (remoteData) ->
      persistence.tag().getSitesHash (localData) ->
        if remoteData.sitesHash != localData.sitesHash
          persistence.remote().getSites (sites) ->
            syncingTranslator = new BH.Lib.SyncingTranslator()
            data = syncingTranslator.forLocal sites
            persistence.tag().import data, ->
              callback()
