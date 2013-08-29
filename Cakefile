coffee = require 'coffee-script'
util = require 'util'
{exec} = require 'child_process'
glob = require 'glob'
fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'


buildScriptTag = (src) ->
  "<script src='#{src}'></script>"

buildStyleTag = (src) ->
  "<link rel='stylesheet' type='text/css' href='#{src}'/>"

popupStyles = [
  'styles/chrome-bootstrap.css',
  'styles/app.css'
  'styles/popup.css'
]

styles = [
  'styles/chrome-bootstrap.css',
  'styles/app.css'
]

popupScripts = [
  'scripts/namespace.js',
  'scripts/frameworks/honeybadger.js',
  'scripts/frameworks/underscore.js',
  'scripts/frameworks/zepto.min.js',
  'scripts/frameworks/backbone.js',
  'scripts/frameworks/mustache.js',
  'scripts/frameworks/analytics.js',
  'scripts/frameworks/mixin.js',
  'scripts/templates.js',
  'scripts/trackers/error_tracker.js',
  'scripts/trackers/analytics_tracker.js',
  'scripts/lib/local_store.js',
  'scripts/modules/i18n.js',
  'scripts/modules/url.js',
  'scripts/models/site.js',
  'scripts/views/main_view.js',
  'scripts/views/tagging_view.js',
  'scripts/views/active_tags_view.js',
  'scripts/initialize_popup.js'
]


scripts = [
  'scripts/namespace.js',
  'scripts/frameworks/honeybadger.js',
  'scripts/frameworks/underscore.js',
  'scripts/frameworks/zepto.min.js',
  'scripts/frameworks/backbone.js',
  'scripts/frameworks/backbone_hacks.js',
  'scripts/frameworks/mustache.js',
  'scripts/frameworks/moment.js',
  'scripts/frameworks/moment_hacks.js',
  'scripts/frameworks/mixin.js',
  'scripts/frameworks/analytics.js',
  'scripts/templates.js',
  'scripts/modules/i18n.js',
  'scripts/modules/url.js',
  'scripts/modules/worker.js',
  'scripts/trackers/error_tracker.js',
  'scripts/trackers/analytics_tracker.js',
  'scripts/lib/date_i18n.js',
  'scripts/lib/history_query.js',
  'scripts/lib/pagination.js',
  'scripts/lib/sync_store.js',
  'scripts/views/modal_view.js',
  'scripts/views/main_view.js',
  'scripts/views/app_view.js',
  'scripts/views/cache.js',
  'scripts/views/credits_view.js',
  'scripts/views/mailing_list_view.js',
  'scripts/views/day_results_view.js',
  'scripts/views/day_view.js',
  'scripts/views/main_view.js',
  'scripts/views/menu_view.js',
  'scripts/views/modal_view.js',
  'scripts/views/prompt_view.js',
  'scripts/views/search_results_view.js',
  'scripts/views/search_pagination_view.js',
  'scripts/views/search_view.js',
  'scripts/views/settings_view.js',
  'scripts/views/visit_view.js',
  'scripts/views/week_view.js',
  'scripts/views/tags_view.js',
  'scripts/views/tag_view.js',
  'scripts/models/history.js',
  'scripts/models/day.js',
  'scripts/models/day_history.js',
  'scripts/models/grouped_visit.js',
  'scripts/models/history.js',
  'scripts/models/interval.js',
  'scripts/models/prompt.js',
  'scripts/models/search.js',
  'scripts/models/search_history.js',
  'scripts/models/settings.js',
  'scripts/models/state.js',
  'scripts/models/visit.js',
  'scripts/models/week.js',
  'scripts/models/week_history.js',
  'scripts/collections/grouped_visits.js',
  'scripts/collections/intervals.js',
  'scripts/collections/visits.js',
  'scripts/collections/weeks.js',
  'scripts/router.js',
  'scripts/initialize_extension.js'
]

task 'concat:templates', 'concat templates', ->
  console.log "Concating templates"
  filepaths = glob.sync("extension/templates/*.html")
  concatedTemplates = ''
  for filepath in filepaths
    key = path.basename(filepath, '.html')
    code = fs.readFileSync(filepath).toString()
    template = code.replace(/\n/g, '').replace(/\"/, '\"')
    concatedTemplates += "BH.Templates.#{key} = \"#{template}\";\n\n"
  filepath = 'build/scripts/templates.js'
  fs.writeFileSync filepath, concatedTemplates

task 'build:assets:dev', '', ->
  code = fs.readFileSync('extension/index.html').toString()

  scriptTags = (buildScriptTag(script) for script in scripts)
  styleTags = (buildStyleTag(style) for style in styles)

  code = code.replace '<%= scripts %>', scriptTags.join("\n    ")
  code = code.replace '<%= styles %>', styleTags.join("\n    ")

  fs.writeFileSync 'build/index.html', code

  code = fs.readFileSync('extension/popup.html').toString()

  scriptTags = (buildScriptTag(script) for script in popupScripts)
  styleTags = (buildStyleTag(style) for style in popupStyles)

  code = code.replace '<%= scripts %>', scriptTags.join("\n    ")
  code = code.replace '<%= styles %>', styleTags.join("\n    ")

  fs.writeFileSync 'build/popup.html', code

task 'build:assets:prod', '', ->
  code = fs.readFileSync('extension/index.html').toString()

  scriptContent = ''
  styleContent = ''

  for script in scripts
    scriptContent += fs.readFileSync("build/#{script}") + "\n\n\n"
  fs.writeFileSync('build/scripts.js', scriptContent)

  for style in styles
    styleContent += fs.readFileSync("build/#{style}") + "\n\n\n"
  fs.writeFileSync('build/styles.css', styleContent)

  code = code.replace '<%= scripts %>', buildScriptTag('scripts.js')
  code = code.replace '<%= styles %>', buildStyleTag('styles.css')

  fs.writeFileSync 'build/index.html', code
