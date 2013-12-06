class BH.Migrations.EnsureDatetimeOnTaggedSites
  name: 'ensure_datetime_on_tagged_sites'

  constructor: (@options) ->

  run: ->
    updateTag = (sites, name) ->
      persistence.tag().removeTag name, ->
        persistence.tag().addSitesToTag sites, name

    persistence.tag().getCompletedMigrations (migrations) =>
      if migrations.indexOf(@name) == -1
        persistence.tag().fetchTags (tags, compiledTags) ->

          for compiledTag in compiledTags
            modifiedSites = []
            modified = false

            for site in compiledTag.sites
              unless site.datetime?
                site.datetime = new Date().getTime()
                modified = true
              modifiedSites.push site

            updateTag(modifiedSites, compiledTag.name) if modified

        persistence.tag().markMigrationAsComplete @name, =>
          @options.analyticsTracker.ensureDatetimeOnTaggedSitesMigration()
