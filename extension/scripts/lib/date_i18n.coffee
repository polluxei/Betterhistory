class BH.Lib.DateI18n extends BH.Base
  @include BH.Modules.I18n

  constructor: ->
    @moment = moment
    @chromeAPI = chrome

  configure: ->
    @moment.lang(@t('chrome_language'))
