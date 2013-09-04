class BH.Presenters.TagPresenter
  constructor: (model) ->
    @model = model

  sites: ->
    sites = @model.get('sites').sort (a,b) ->
      b.datetime - a.datetime
    sites: sites
