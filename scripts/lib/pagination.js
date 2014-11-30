(function() {
  var Pagination = {
    RESULTS_PER_PAGE: 100,

    calculatePages: function(resultAmount) {
      return Math.ceil(resultAmount / this.RESULTS_PER_PAGE);
    },

    calculateBounds: function(page) {
      var start = page * this.RESULTS_PER_PAGE,
          end = null;

      if(page === 0) {
        end = this.RESULTS_PER_PAGE;
      } else {
        end = page * this.RESULTS_PER_PAGE + this.RESULTS_PER_PAGE;
      }

      return [start, end];
    }
  };

  BH.Lib.Pagination = Pagination;
})();
