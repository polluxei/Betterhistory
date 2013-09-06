class BH.Models.Tag extends Backbone.Model
  initialize: (attrs = {}, options = {}) ->
    throw "Persistence is not set" unless options.persistence?
    @persistence = options.persistence

  fetch: (callback = ->) ->
    @persistence.fetchTagSites @get('name'), (sites) =>
      @set sites: sites
      callback()

  destroy: (callback = ->) ->
    @persistence.removeTag @get('name'), =>
      @set sites: []
      callback()

  removeSite: (url, callback = ->) ->
    @persistence.removeSiteFromTag url, @get('name'), (sites) =>
      @set sites: sites
      callback()
