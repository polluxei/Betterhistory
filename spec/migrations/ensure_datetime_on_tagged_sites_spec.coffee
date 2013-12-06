describe 'BH.Migrations.EnsureDatetimeOnTaggedSites', ->
  beforeEach ->
    timekeeper.freeze(new Date(1351029600000))

    @migration = new BH.Migrations.EnsureDatetimeOnTaggedSites()

  describe '#run', ->
    describe 'when the migration has not been run', ->
      beforeEach ->
        persistence.tag().getCompletedMigrations.andCallFake (callback) ->
          callback([])
        persistence.tag().removeTag.andCallFake (name, cb) -> cb()
        persistence.tag().fetchTags.andCallFake (callback) ->
          callback ['cooking'], [
            name: 'cooking'
            sites: [
              {
                title: 'baking tips'
                url: 'http://baking.com/tips'
              }, {
                title: 'baking secrets'
                url: 'http://baking.com/secrets'
              }
            ]
          ]

      it 'updates the sites with a datetime and saves them', ->
        @migration.run()
        expect(persistence.tag().addSitesToTag).toHaveBeenCalledWith [
          {
            title: 'baking tips'
            url: 'http://baking.com/tips'
            datetime: 1351029600000
          }, {
            title: 'baking secrets'
            url: 'http://baking.com/secrets'
            datetime: 1351029600000
          }
        ], 'cooking'

      it 'only updates the sites when needed', ->
        persistence.tag().fetchTags.andCallFake (callback) ->
          callback ['cooking'], [
            name: 'cooking'
            sites: [
              {
                title: 'baking tips'
                url: 'http://baking.com/tips'
                datetime: 1234
              }, {
                title: 'baking secrets'
                url: 'http://baking.com/secrets'
                datetime: 1234
              }
            ]
          ]
        @migration.run()
        expect(persistence.tag().addSitesToTag).not.toHaveBeenCalled()

      it 'marks the migration as complete', ->
        @migration.run()
        expect(persistence.tag().markMigrationAsComplete).toHaveBeenCalledWith 'ensure_datetime_on_tagged_sites', jasmine.any(Function)

    describe 'when the migration has been run', ->
      beforeEach ->
        persistence.tag().getCompletedMigrations.andCallFake (callback) ->
          callback(['ensure_datetime_on_tagged_sites'])

      it 'does not run again', ->
        @migration.run()
        expect(persistence.tag().fetchTags).not.toHaveBeenCalled()
