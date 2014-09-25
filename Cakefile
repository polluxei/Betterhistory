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

styles = [
  'styles/chrome-bootstrap.css',
  'styles/app.css'
  'styles/i18n.css'
  'styles/fontello.css'
  'styles/pictonic.css'
]

backgroundScripts = [
  "scripts/namespace.js",
  "scripts/frameworks/honeybadger.js",
  "scripts/frameworks/underscore.js",
  "scripts/frameworks/mixin.js",
  "scripts/frameworks/analytics.js",
  'scripts/frameworks/sha1.js',
  "scripts/modules/worker.js",
  "scripts/modules/i18n.js",
  "scripts/modules/url.js",
  "scripts/trackers/error_tracker.js",
  "scripts/trackers/analytics_tracker.js",
  "scripts/chrome/page_context_menu.js",
  "scripts/chrome/selection_context_menu.js",
  "scripts/chrome/omnibox.js",
  "scripts/chrome/browser_actions.js",
  "scripts/chrome/sync_store.js",
  "scripts/chrome/local_store.js",
  "scripts/lib/example_tags.js",
  'scripts/lib/syncing_translator.js',
  'scripts/lib/sites_hasher.js',
  'scripts/migrations/ensure_datetime_on_tagged_sites.js',
  'scripts/persistence/tag.js',
  'scripts/persistence/remote.js',
  "scripts/init/tag_feature.js",
  "scripts/init/persistence.js",
  "scripts/initialize_background.js"
]

scripts = [
  'scripts/namespace.js',
  'scripts/historian.js',
  'scripts/frameworks/honeybadger.js',
  'scripts/frameworks/underscore.js',
  'scripts/frameworks/zepto.min.js',
  'scripts/frameworks/zepto_additions.js',
  'scripts/frameworks/backbone.js',
  'scripts/frameworks/backbone_hacks.js',
  'scripts/frameworks/mustache.js',
  'scripts/frameworks/moment-with-langs.min.js',
  'scripts/frameworks/mixin.js',
  'scripts/frameworks/analytics.js',
  'scripts/frameworks/sha1.js',
  'scripts/frameworks/EventEmitter.min.js',
  'scripts/templates.js',
  'scripts/modules/i18n.js',
  'scripts/modules/url.js',
  'scripts/trackers/error_tracker.js',
  'scripts/trackers/analytics_tracker.js',
  'scripts/lib/date_i18n.js',
  'scripts/lib/pagination.js',
  'scripts/lib/example_tags.js',
  'scripts/lib/image_data.js',
  'scripts/lib/google_user_info.js',
  'scripts/lib/user_processor.js',
  'scripts/lib/syncing_translator.js',
  'scripts/lib/sites_hasher.js',
  'scripts/lib/syncer.js',
  'scripts/lib/query_params.js',
  'scripts/chrome/sync_store.js',
  'scripts/chrome/local_store.js',
  'scripts/persistence/tag.js',
  'scripts/persistence/remote.js',
  'scripts/modals/base.js',
  'scripts/modals/rename_tag_modal.js',
  'scripts/modals/read_only_explanation_modal.js',
  'scripts/modals/credits_modal.js',
  'scripts/modals/mailing_list_modal.js',
  'scripts/modals/how_to_tag_modal.js',
  'scripts/modals/new_tag_modal.js',
  'scripts/modals/initial_syncing_modal.js',
  'scripts/modals/syncing_decision_modal.js',
  'scripts/modals/auth_error_modal.js',
  'scripts/modals/server_error_modal.js',
  'scripts/modals/connection_required_modal.js',
  'scripts/modals/login_error_modal.js',
  'scripts/views/main_view.js',
  'scripts/views/app_view.js',
  'scripts/views/cache.js',
  'scripts/views/main_view.js',
  'scripts/views/menu_view.js',
  'scripts/views/modal_view.js',
  'scripts/views/prompt_view.js',
  'scripts/views/search_results_view.js',
  'scripts/views/search_pagination_view.js',
  'scripts/views/search_view.js',
  'scripts/views/search_controls_view.js',
  'scripts/views/settings_view.js',
  'scripts/views/visit_view.js',
  'scripts/views/tags_view.js',
  'scripts/views/tags_list_view.js',
  'scripts/views/tag_view.js',
  'scripts/views/tagged_sites_view.js',
  'scripts/views/drag_and_tag_view.js',
  'scripts/views/active_tags_view.js',
  'scripts/views/available_tags_view.js',
  'scripts/views/devices_view.js',
  'scripts/views/devices_list_view.js',
  'scripts/views/devices_results_view.js',
  'scripts/views/menu_view.js',
  'scripts/views/visits_view.js',
  'scripts/views/visits_results_view.js',
  'scripts/views/timeline_view.js',
  'scripts/views/visit_view.js',
  'scripts/models/history.js',
  'scripts/models/prompt.js',
  'scripts/models/search.js',
  'scripts/models/settings.js',
  'scripts/models/tag.js',
  'scripts/models/site.js',
  'scripts/models/user.js',
  'scripts/collections/tags.js',
  'scripts/collections/sites.js',
  'scripts/collections/devices.js',
  'scripts/presenters/base.js',
  'scripts/presenters/tag_presenter.js',
  'scripts/presenters/tags_presenter.js',
  'scripts/presenters/sites_presenter.js',
  'scripts/presenters/search_presenter.js',
  'scripts/presenters/search_history_presenter.js',
  'scripts/presenters/settings_presenter.js',
  'scripts/presenters/devices_presenter.js',
  'scripts/presenters/timeline_presenter.js',
  'scripts/presenters/visits_presenter.js',
  'scripts/router.js',
  'scripts/init/tag_feature.js',
  'scripts/init/mailing_list.js',
  'scripts/init/persistence.js',
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
  manifest = fs.readFileSync('extension/manifest.json').toString()

  backgroundScripts = ("\"#{script}\"" for script in backgroundScripts)
  manifest = manifest.replace '<%= scripts %>', backgroundScripts.join(",\n      ")

  fs.writeFileSync 'build/manifest.json', manifest

  code = fs.readFileSync('extension/index.html').toString()

  scriptTags = (buildScriptTag(script) for script in scripts)
  styleTags = (buildStyleTag(style) for style in styles)

  code = code.replace '<%= scripts %>', scriptTags.join("\n    ")
  code = code.replace '<%= styles %>', styleTags.join("\n    ")
  code = code.replace '<%= wallet.js %>', 'https://sandbox.google.com/checkout/inapp/lib/buy.js'

  fs.writeFileSync 'build/index.html', code

task 'build:assets:prod', '', ->
  manifest = fs.readFileSync('build/manifest.json').toString()

  backgroundScriptContent = ''

  for script in backgroundScripts
    backgroundScriptContent += fs.readFileSync("build/#{script}") + "\n\n\n"
  fs.writeFileSync('build/scripts/background_script.js', backgroundScriptContent)

  manifest = manifest.replace '<%= scripts %>', '"scripts/background_script.js"'

  fs.writeFileSync 'build/manifest.json', manifest

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
  code = code.replace '<%= wallet.js %>', 'https://wallet.google.com/inapp/lib/buy.js'

  fs.writeFileSync 'build/index.html', code
