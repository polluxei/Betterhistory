(function() {
  var SearchPresenter = function(search) {
    this.search = search;
  };

  SearchPresenter.prototype.searchInfo = function() {
    var terms = [];
    if(this.search.query) {
      terms = this.search.query.split(' ');
    }
    joined = chrome.i18n.getMessage('searching_title') + ' ';

    // yuck
    terms.forEach(function(term, i) {
      joined += '"' + term + '"';
      if(i !== terms.length - 1) {
        joined += " " + chrome.i18n.getMessage('and') + " ";
      }
    });

    return _.extend(this.search, {title: joined});
  };

  BH.Presenters.SearchPresenter = SearchPresenter;
})();
