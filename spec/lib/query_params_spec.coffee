describe "BH.Lib.QueryParams", ->
  describe ".read", ->
    it "returns an object representing the passed querystring", ->
      obj = BH.Lib.QueryParams.read("test=value&value=bananas")
      expect(obj).toEqual
        test: 'value'
        value: 'bananas'

  describe ".write", ->
    it "returns a query string representing the passed object", ->
      string = BH.Lib.QueryParams.write test: 'value', value: 'bananas'
      expect(string).toEqual '?test=value&value=bananas'

    it "returns a empty string when the passed object is empty", ->
      string = BH.Lib.QueryParams.write {}
      expect(string).toEqual ''
