BH.Modules.Worker =
  worker: (name, options, callback) ->
    basePath = 'scripts/workers'
    path = switch name
      when 'sanitizer'
        "#{basePath}/sanitizer.js"
      when 'rangeSanitizer'
        "#{basePath}/range_sanitizer.js"
      when 'domainGrouper'
        "#{basePath}/domain_grouper.js"
      when 'timeGrouper'
        "#{basePath}/time_grouper.js"
      when 'dayGrouper'
        "#{basePath}/day_grouper.js"
      when 'weekGrouper'
        "#{basePath}/week_grouper.js"

    worker = new Worker(path)

    worker.onmessage = (e) ->
      if (e.data.log)
        console.log(e.data.log)
      else
        callback(e.data)
        worker.terminate()
    worker.postMessage(options)
