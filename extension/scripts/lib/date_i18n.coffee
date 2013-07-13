class BH.Lib.DateI18n extends BH.Base
  @include BH.Modules.I18n

  constructor: ->
    @moment = moment
    @chromeAPI = chrome

  configure: ->
    @moment.lang @t('chrome_language'),
      months: [
        @t('january')
        @t('february')
        @t('march')
        @t('april')
        @t('may')
        @t('june')
        @t('july')
        @t('august')
        @t('september')
        @t('october')
        @t('november')
        @t('december')
      ]

      weekdays: [
        @t('sunday')
        @t('monday')
        @t('tuesday')
        @t('wednesday')
        @t('thursday')
        @t('friday')
        @t('saturday')
      ]

      longDateFormat:
        LT: @t('local_time')
        L: @t('short_date')
        LL: @t('short_date_with_day')
        LLL: @t('formal_date')

      meridiem: (hour, minute, isLower) =>
        if hour < 12
          @t('morning')
        else if hour >= 12 && hour < 16
          @t('afternoon')
        else if hour >= 16
          @t('evening')

      ordinal: (number) =>
        @t("ordinal_" + number)

    @moment.lang(@t('chrome_language'))
