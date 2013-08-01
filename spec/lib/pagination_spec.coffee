describe 'BH.Lib.Pagination', ->
  describe '#calculatePages', ->
    it 'returns the number of pages for the number passed', ->
      expect(BH.Lib.Pagination.calculatePages(0)).toEqual 0
      expect(BH.Lib.Pagination.calculatePages(1)).toEqual 1
      expect(BH.Lib.Pagination.calculatePages(100)).toEqual 1
      expect(BH.Lib.Pagination.calculatePages(101)).toEqual 2
      expect(BH.Lib.Pagination.calculatePages(250)).toEqual 3

  describe '#calculateBounds', ->
    it 'returns the starting and ending result numbers for the passed page', ->
      expect(BH.Lib.Pagination.calculateBounds(0)).toEqual [0, 100]
      expect(BH.Lib.Pagination.calculateBounds(1)).toEqual [100, 200]
      expect(BH.Lib.Pagination.calculateBounds(2)).toEqual [200, 300]
