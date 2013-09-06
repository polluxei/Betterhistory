BH.Modules.Url =
  urlFor: (key, id, opts) ->
    base = 'chrome://history/'
    return base unless key?

    buildBase = (opts) ->
      if opts?.absolute then base else ''

    route =
      switch key
        when 'search'
          "#search/#{id}"
        when 'week'
          "#weeks/#{id}"
        when 'day'
          "#days/#{id}"
        when 'tag'
          "#tags/#{id}"

    "#{buildBase(opts)}#{route}"
