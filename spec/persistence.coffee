getPersistence = ->
  tag:
    fetchTagSites: jasmine.createSpy('fetchTagSites')
    removeTag: jasmine.createSpy('removeTag')
    removeSiteFromTag: jasmine.createSpy('removeSiteFromTag')
    renameTag: jasmine.createSpy('renameTag')
    fetchSharedTag: jasmine.createSpy('fetchSharedTag')
    import: jasmine.createSpy('import')
    fetchTags: jasmine.createSpy('fetchTags')
    fetchSiteTags: jasmine.createSpy('fetchSiteTags')
    removeAllTags: jasmine.createSpy('removeAllTags')
    addSitesToTag: jasmine.createSpy('addSitesToTag')
    addSiteToTag: jasmine.createSpy('addSiteToTag')
    removeSitesFromTag: jasmine.createSpy('removeSitesFromTag')
  remote:
    renameTag: jasmine.createSpy('renameTag')
    deleteTag: jasmine.createSpy('deleteTag')
    updateSites: jasmine.createSpy('updateSites')
    updateSite: jasmine.createSpy('updateSite')

module.exports = ->
  reset: ->
    persistence = getPersistence()

    tag: -> persistence.tag
    remote: -> persistence.remote
