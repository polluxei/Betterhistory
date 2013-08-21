underscore = require 'underscore'
backbone = require 'backbone'
moment = require 'moment'
timekeeper = require 'timekeeper'

global.onServer = typeof exports != 'undefined'
global._ = underscore
global.Backbone = backbone
global.moment = moment
global.timekeeper = timekeeper
global.mockChromeAPI = require './chrome_api'
global.chrome = mockChromeAPI()
global.BH = require '../extension/scripts/namespace'

require '../extension/scripts/frameworks/backbone_hacks.js'
require '../extension/scripts/frameworks/mixin.js'
require '../extension/scripts/frameworks/moment_hacks.js'
require '../extension/scripts/modules/url.coffee'
require '../extension/scripts/modules/i18n.coffee'
require '../extension/scripts/modules/worker.coffee'
require '../extension/scripts/lib/date_i18n.coffee'
require '../extension/scripts/lib/browser_actions.coffee'
require '../extension/scripts/lib/page_context_menu.coffee'
require '../extension/scripts/lib/selection_context_menu.coffee'
require '../extension/scripts/lib/history_query.coffee'
require '../extension/scripts/lib/pagination.coffee'
require '../extension/scripts/lib/omnibox.coffee'
require '../extension/scripts/lib/tracker.coffee'
require '../extension/scripts/lib/sync_store.coffee'
require '../extension/scripts/workers/day_grouper.coffee'
require '../extension/scripts/workers/domain_grouper.coffee'
require '../extension/scripts/workers/time_grouper.coffee'
require '../extension/scripts/workers/sanitizer.coffee'
require '../extension/scripts/models/history.coffee'
require '../extension/scripts/models/week.coffee'
require '../extension/scripts/models/day.coffee'
require '../extension/scripts/models/visit.coffee'
require '../extension/scripts/models/search.coffee'
require '../extension/scripts/models/settings.coffee'
require '../extension/scripts/models/state.coffee'
require '../extension/scripts/models/day_history.coffee'
require '../extension/scripts/models/week_history.coffee'
require '../extension/scripts/models/search_history.coffee'
require '../extension/scripts/models/settings.coffee'
require '../extension/scripts/collections/weeks.coffee'
require '../extension/scripts/collections/visits.coffee'

new BH.Lib.DateI18n().configure()
global.tracker = new BH.Lib.Tracker([])
