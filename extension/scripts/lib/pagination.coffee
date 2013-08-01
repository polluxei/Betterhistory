BH.Lib.Pagination =
  RESULTS_PER_PAGE: 100

  calculatePages: (resultAmount) ->
    Math.ceil(resultAmount / @RESULTS_PER_PAGE)

  calculateBounds: (page) ->
    start = page * @RESULTS_PER_PAGE
    end = if page == 0
      @RESULTS_PER_PAGE
    else
      page * @RESULTS_PER_PAGE + @RESULTS_PER_PAGE

    [start, end]
