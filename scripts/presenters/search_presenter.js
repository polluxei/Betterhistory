(function() {
  var SearchPresenter = function(search) {
    this.search = search;
  };

  SearchPresenter.prototype.searchInfo = function() {
    var terms = [];

    if(this.search.query) {
      if(this.search.query.match(/^\/.*\/$/)) {
        terms = this.search.query.slice(1, -1);
      } else {
        terms = this.search.query.split(' ');
      }
    }

    var joined = chrome.i18n.getMessage('searching_title') + ' ';

    if(Array.isArray(terms)) {
      terms.forEach(function(term, i) {
        joined += '"' + term + '"';
        if(i !== terms.length - 1) {
          joined += " " + chrome.i18n.getMessage('and') + " ";
        }
      });
    } else {
      joined += '<ul class="tags"><li>' + terms + '</li></ul>';
    }

    return _.extend(this.search, {title: joined});
  };

  BH.Presenters.SearchPresenter = SearchPresenter;
})();
