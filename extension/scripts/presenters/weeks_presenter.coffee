class BH.Presenters.WeeksPresenter extends BH.Presenters.Base
  constructor: (@collection) ->

  weeks: ->
    weeks = for model in @collection.models
      out =
        id: model.id
        url: "#weeks/#{model.id}"
        shortTitle: model.get('date').format('L')

    weeks: weeks
