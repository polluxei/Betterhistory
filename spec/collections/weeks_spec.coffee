describe 'BH.Collections.Weeks', ->
  beforeEach ->
    @weeks = new BH.Collections.Weeks null,
      settings: new BH.Models.Settings()

  describe '#reload', ->
    beforeEach ->
      timekeeper.freeze(new Date('10-23-12'))

    afterEach ->
      timekeeper.reset()

    it 'reloads the weeks with the passed starting day', ->
      @weeks.reload('Monday')
      dates = for model in @weeks.models
        model.id

      expect(dates).toEqual [
        '10-22-12', '10-15-12', '10-8-12', '10-1-12', '9-24-12',
        '9-17-12', '9-10-12'
      ]
