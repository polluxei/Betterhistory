class BH.Presenters.SitePresenter
  constructor: (model) ->
    @model = model

  site: ->
    match = @model.get('url').match(/\/\/(.*?)\//)
    domain = if match == null then null else match[1]
    domain = domain.replace('www.', '') if domain

    out = @model.toJSON()
    out.domain = domain

    out
