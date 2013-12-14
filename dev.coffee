watch = require('watch')
exec = require('child_process').exec
watch.createMonitor '/Users/roykolak/Sites/better-history/extension', (monitor) ->
  callback = (f) ->
    if f.match /.coffee$|.html$|.json$/
      console.log f
      exec('make build')

  monitor.on "changed", callback
  monitor.on "removed", callback
  monitor.on "created", callback
