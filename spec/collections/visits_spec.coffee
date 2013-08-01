describe 'BH.Collections.Visits', ->
  beforeEach ->
    @visits = new BH.Collections.Visits()

  describe '#toTemplate', ->
    beforeEach ->
      visit1 = new BH.Models.Visit()
      spyOn(visit1, 'toTemplate').andReturn('templated visit 1')

      visit2 = new BH.Models.Visit()
      spyOn(visit2, 'toTemplate').andReturn('templated visit 2')

      visit3 = new BH.Models.Visit()
      spyOn(visit3, 'toTemplate').andReturn('templated visit 3')

      visit4 = new BH.Models.Visit()
      spyOn(visit4, 'toTemplate').andReturn('templated visit 4')

      @visits.add([visit1, visit2, visit3, visit4])

    it 'returns the templated models', ->
      expect(@visits.toTemplate()).toEqual
        visits: ['templated visit 1', 'templated visit 2', 'templated visit 3', 'templated visit 4']

    describe 'when passed a start and end place', ->
      it 'returns the segment of visits between the start and end numbers', ->
        expect(@visits.toTemplate(1, 3)).toEqual
          visits: ['templated visit 2', 'templated visit 3']
