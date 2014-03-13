underscore = require 'underscore'
backbone = require 'backbone'
moment = require 'moment'
timekeeper = require 'timekeeper'

global.onServer = typeof exports != 'undefined'
global._ = underscore
global.Backbone = backbone
global.moment = moment
global.timekeeper = timekeeper

mockChromeAPI = require './chrome_api'
mockPersistence = require './persistence'
global.chrome = mockChromeAPI()

global.BH = require '../extension/scripts/namespace'

global.apiHost = 'api.better-history.com'

global.navigator = {}

global.EventEmitter = require('events').EventEmitter

require '../extension/scripts/frameworks/backbone_hacks.js'
require '../extension/scripts/frameworks/mixin.js'
require '../extension/scripts/frameworks/moment_hacks.js'
require '../extension/scripts/modules/url.coffee'
require '../extension/scripts/modules/i18n.coffee'
require '../extension/scripts/modules/worker.coffee'
require '../extension/scripts/trackers/analytics_tracker.coffee'
require '../extension/scripts/trackers/error_tracker.coffee'
require '../extension/scripts/lib/date_i18n.coffee'
require '../extension/scripts/lib/pagination.coffee'
require '../extension/scripts/lib/example_tags.coffee'
require '../extension/scripts/lib/image_data.coffee'
require '../extension/scripts/lib/day_history.coffee'
require '../extension/scripts/lib/week_history.coffee'
require '../extension/scripts/lib/weeks_history.coffee'
require '../extension/scripts/lib/search_history.coffee'
require '../extension/scripts/lib/syncing_translator.coffee'
require '../extension/scripts/migrations/ensure_datetime_on_tagged_sites.coffee'
require '../extension/scripts/persistence/tag.coffee'
require '../extension/scripts/persistence/remote.coffee'
require '../extension/scripts/workers/day_grouper.coffee'
require '../extension/scripts/workers/week_grouper.coffee'
require '../extension/scripts/workers/domain_grouper.coffee'
require '../extension/scripts/workers/time_grouper.coffee'
require '../extension/scripts/workers/search_sanitizer.coffee'
require '../extension/scripts/workers/range_sanitizer.coffee'
require '../extension/scripts/chrome/page_context_menu.coffee'
require '../extension/scripts/chrome/selection_context_menu.coffee'
require '../extension/scripts/chrome/omnibox.coffee'
require '../extension/scripts/chrome/history.coffee'
require '../extension/scripts/chrome/sync_store.coffee'
require '../extension/scripts/chrome/local_store.coffee'
require '../extension/scripts/models/settings.coffee'
require '../extension/scripts/models/state.coffee'
require '../extension/scripts/models/settings.coffee'
require '../extension/scripts/models/site.coffee'
require '../extension/scripts/models/tag.coffee'
require '../extension/scripts/models/user.coffee'
require '../extension/scripts/collections/weeks.coffee'
require '../extension/scripts/collections/tags.coffee'
require '../extension/scripts/collections/sites.coffee'
require '../extension/scripts/presenters/base.coffee'
require '../extension/scripts/presenters/tag_presenter.coffee'
require '../extension/scripts/presenters/tags_presenter.coffee'
require '../extension/scripts/presenters/site_presenter.coffee'
require '../extension/scripts/presenters/day_presenter.coffee'
require '../extension/scripts/presenters/week_presenter.coffee'
require '../extension/scripts/presenters/weeks_presenter.coffee'
require '../extension/scripts/presenters/search_presenter.coffee'
require '../extension/scripts/presenters/week_history_presenter.coffee'
require '../extension/scripts/presenters/day_history_presenter.coffee'
require '../extension/scripts/presenters/search_history_presenter.coffee'
require '../extension/scripts/presenters/settings_presenter.coffee'
require '../extension/scripts/presenters/calendar_presenter.coffee'
require '../extension/scripts/init/tag_feature.coffee'
require '../extension/scripts/init/mailing_list.coffee'
require '../extension/scripts/init/persistence.coffee'

new BH.Lib.DateI18n().configure()

beforeEach ->
  spyOn(BH.Lib.ImageData, 'base64').andCallFake (url, callback) ->
    callback('favicon image')

  global.chrome = mockChromeAPI()
  global.persistence = mockPersistence().reset()
