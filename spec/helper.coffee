underscore = require 'underscore'
backbone = require 'backbone'
moment = require 'moment'
timekeeper = require 'timekeeper'

global.onServer = typeof exports != 'undefined'
global._ = underscore
global.Backbone = backbone
global.moment = moment
global.timekeeper = timekeeper
global.localStorage = {}
global.mockChromeAPI = require './chrome_api'
global.chrome = mockChromeAPI()
global.BH = require '../extension/scripts/namespace'

require '../extension/scripts/frameworks/backbone_hacks.js'
require '../extension/scripts/frameworks/mixin.js'
require '../extension/scripts/frameworks/moment_hacks.js'
require '../extension/scripts/modules/url'
require '../extension/scripts/modules/i18n'
require '../extension/scripts/modules/worker'
require '../extension/scripts/lib/date_i18n'
require '../extension/scripts/lib/browser_actions'
require '../extension/scripts/lib/page_context_menu'
require '../extension/scripts/lib/selection_context_menu'
require '../extension/scripts/lib/history_query'
require '../extension/scripts/lib/pagination'
require '../extension/scripts/workers/day_grouper'
require '../extension/scripts/workers/domain_grouper'
require '../extension/scripts/workers/time_grouper'
require '../extension/scripts/workers/sanitizer'
require '../extension/scripts/models/history'
require '../extension/scripts/models/week'
require '../extension/scripts/models/day'
require '../extension/scripts/models/visit'
require '../extension/scripts/models/search'
require '../extension/scripts/models/settings'
require '../extension/scripts/models/state'
require '../extension/scripts/models/day_history'
require '../extension/scripts/models/week_history'
require '../extension/scripts/models/search_history'
require '../extension/scripts/models/settings'
require '../extension/scripts/collections/weeks'
require '../extension/scripts/collections/visits'

new BH.Lib.DateI18n().configure()
