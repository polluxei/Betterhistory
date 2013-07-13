BH.Modules.I18n =
  t: (key, replacements = []) ->
    if key instanceof Array
      keys = key
      lookup = {}
      for key in keys
        lookup["i18n_#{key}"] = @chromeAPI.i18n.getMessage(key.toString())
      lookup
    else
      @chromeAPI.i18n.getMessage key, replacements
